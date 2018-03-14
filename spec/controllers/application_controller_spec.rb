# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, type: :controller do
  describe 'options' do
    it 'should head okay' do
      get :options
      expect(response).to be_ok
      expect(response.body).to eq ''
    end
  end

  describe 'options route' do
    let(:constraints) { %i[post put patch delete] }

    it 'should be okay' do
      constraints.each do |constraint|
        send(constraint, :options)
        expect(response).to be_ok
      end
    end
  end
end
