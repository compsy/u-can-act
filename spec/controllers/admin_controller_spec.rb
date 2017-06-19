# frozen_string_literal: true

require 'rails_helper'

describe AdminController, type: :controller do

  describe "GET 'routes'" do
    let(:routes_list) { %i[index person_export protocol_subscription_export] }

    it 'should require basic http auth' do
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'should require the correct username' do
      basic_auth 'otherusername', 'admin'
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'should require correct password' do
      basic_auth 'admin', 'otherpassword'
      routes_list.each do |route|
        get route
        expect(response).to be_unauthorized
      end
    end

    it 'response should be ok if authorized', focus: true do
      basic_auth 'admin', 'admin'
      routes_list.each do |route|
        get route
        expect(response).to be_ok
      end
    end
  end
end
