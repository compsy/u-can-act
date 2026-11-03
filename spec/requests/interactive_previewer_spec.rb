# frozen_string_literal: true

require 'rails_helper'

describe 'Interactive questionnaire previewer', type: :request do
  let(:markup) { '<span class="preview-marker">raw</span>' }
  let(:content) do
    { questions: [{ id: :v1, type: :raw, content: markup, title: markup }], scores: [] }.to_json
  end
  let(:admin_env) { { 'HTTP_AUTHORIZATION' => basic_encode('admin', 'admin') } }

  shared_examples 'a denied previewer request' do
    it 'denies GET /questionnaire/interactive' do
      get '/questionnaire/interactive', env: env
      expect(response).to have_http_status(:unauthorized)
    end

    it 'denies POST /questionnaire/interactive_post' do
      post '/questionnaire/interactive_post', params: { content: Base64.strict_encode64(content) }, env: env
      expect(response).to have_http_status(:unauthorized)
    end

    it 'denies POST /questionnaire/interactive_render and does not render the posted markup' do
      post '/questionnaire/interactive_render', params: { content: content }, env: env
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).not_to include(markup)
      expect(response.body).not_to include('preview-marker')
    end

    it 'denies POST /questionnaire/from_json' do
      post '/questionnaire/from_json', env: env
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'without credentials' do
    let(:env) { {} }

    it_behaves_like 'a denied previewer request'
  end

  describe 'with wrong admin credentials' do
    let(:env) { { 'HTTP_AUTHORIZATION' => basic_encode('admin', 'wrong') } }

    it_behaves_like 'a denied previewer request'
  end

  describe 'as a logged in participant' do
    let(:the_auth_user) { FactoryBot.create(:auth_user, :with_person) }
    let(:env) { {} }

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('BASE_PLATFORM_URL', nil).and_return('https://platform.example')
      cookies[SdvLaunchController::PLATFORM_SESSION_COOKIE] =
        "Bearer #{jwt_auth({ 'sub' => the_auth_user.auth0_id_string }, false)}"
      get '/sdv/launch', params: { return_to: '/questionnaire' }
      expect(response).to have_http_status(:see_other)
    end

    it_behaves_like 'a denied previewer request'
  end

  describe 'as an admin' do
    it 'shows the previewer' do
      get '/questionnaire/interactive', env: admin_env
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Questionnaire JSON')
    end

    it 'renders the posted questionnaire' do
      post '/questionnaire/interactive_render', params: { content: content }, env: admin_env
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Test questionnaire')
      expect(response.body).to include(markup)
    end

    it 'redirects back to the previewer after a submit' do
      post '/questionnaire/from_json', env: admin_env
      expect(response).to redirect_to('/questionnaire/interactive')
    end

    it 'escapes the posted content in the previewer text area' do
      posted = '</textarea><script>marker</script>'
      post '/questionnaire/interactive_post', params: { content: Base64.strict_encode64(posted) }, env: admin_env
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include(posted)
      expect(response.body).to include('&lt;/textarea&gt;&lt;script&gt;marker&lt;/script&gt;')
    end
  end

  describe 'with forgery protection' do
    around do |example|
      show_exceptions = Rails.application.env_config['action_dispatch.show_exceptions']
      Rails.application.env_config['action_dispatch.show_exceptions'] = :all
      ActionController::Base.allow_forgery_protection = true
      example.run
    ensure
      ActionController::Base.allow_forgery_protection = false
      Rails.application.env_config['action_dispatch.show_exceptions'] = show_exceptions
    end

    def csrf_token_from_previewer
      get '/questionnaire/interactive', env: admin_env
      Nokogiri::HTML(response.body).at('meta[name="csrf-token"]')['content']
    end

    it 'rejects an admin render without a CSRF token' do
      post '/questionnaire/interactive_render', params: { content: content }, env: admin_env
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).not_to include(markup)
    end

    it 'rejects an admin post to the previewer without a CSRF token' do
      post '/questionnaire/interactive_post', params: { content: Base64.strict_encode64(content) }, env: admin_env
      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'rejects an admin submit without a CSRF token' do
      post '/questionnaire/from_json', env: admin_env
      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'renders for an admin with the CSRF token of the previewer page' do
      token = csrf_token_from_previewer
      post '/questionnaire/interactive_render', params: { content: content },
                                                headers: { 'X-CSRF-Token' => token }, env: admin_env
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(markup)
    end

    it 'adds a CSRF token to the rendered form' do
      token = csrf_token_from_previewer
      post '/questionnaire/interactive_render', params: { content: content },
                                                headers: { 'X-CSRF-Token' => token }, env: admin_env
      form_token = Nokogiri::HTML(response.body).at('form input[name="authenticity_token"]')
      expect(form_token).to be_present
      expect(form_token['value']).to be_present
    end
  end
end
