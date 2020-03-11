# frozen_string_literal: true

# The methods of this helper are tested two controllers:
# - api/v1/basic_auth_api/questionnaires_controller
# - api/v1/jwt_api/questionnaire_controller
module QuestionnaireCreateHelper
  def create_questionnaire
    fqparams = questionnaire_params.to_hash.with_indifferent_access
    fqparams[:content] = full_content(fqparams[:content]) if fqparams.key?(:content)
    questionnaire = Questionnaire.new(fqparams)
    if questionnaire.save
      render status: :created, json: { result: 'Questionnaire created.' }
    else
      result = { result: questionnaire.errors }
      render(status: :bad_request, json: result)
    end
  end

  private

  def full_content(content)
    full_content = content.deep_dup
    full_content[:scores] = [] unless full_content.key?(:scores)
    full_content[:questions] = [] unless full_content.key?(:questions)
    full_content
  end

  def questionnaire_params
    load_params = params.require(:questionnaire).permit(:name, :key, :title)

    # Whitelist the hash
    # see https://github.com/rails/rails/issues/9454
    load_params[:content] = params[:questionnaire][:content] if params[:questionnaire][:content]
    load_params.permit!
  end
end
