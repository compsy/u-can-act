# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::PersonController, type: :controller do
  let(:team) { FactoryBot.create(:team) }

  let(:student_role) { FactoryBot.create(:role, :student, team: team) }
  let(:mentor_role) { FactoryBot.create(:role, :mentor, team: team) }

  let(:person) { FactoryBot.create(:person, :with_iban, role: mentor_role, email: 'test@test2.com') }
  let(:student) { FactoryBot.create(:person, role: student_role) }
  let(:protocol) { FactoryBot.create(:protocol) }
  before :each do
    student_role.reload
    mentor_role.reload
  end

  let(:valid_person_params) do
    {
      person: {
        first_name: 'First',
        last_name: 'Last',
        gender: Person::MALE,
        mobile_phone: '0612341234',
        role_id: student_role.id
      },
      role: {
        uuid: student_role.uuid
      }
    }
  end

  describe 'when not logged in' do
    it 'should not show' do
      get :me
      expect(response.status).to eq 401
    end

    it 'should not create' do
      post :create, params: { first_name: 'test', last_name: 'Last name',
                              mobile_phone: '0612341234', protocol_id: protocol.id }
      expect(response.status).to eq 401
    end
  end

  describe 'when logged in' do
    before :each do
      cookie_auth(person)
    end

    describe 'create' do
      it_should_behave_like 'an is_logged_in_as_mentor concern', 'post', :create

      describe 'validates role id' do
        it 'should head 403 if the provided role is not a student role in the correct organization' do
          valid_person_params[:role][:uuid] = mentor_role.uuid
          post :create, params: valid_person_params
          expect(response.status).to eq 403
        end
      end

      context 'invalid person' do
        let(:person_params) do
          {
            person: { mobile_phone: '0612341234' },
            role: {
              uuid: student_role.uuid
            }
          }
        end

        it 'should not create a person' do
          pre_count = Person.count
          post :create, params: person_params
          expect(Person.count).to eq pre_count
        end

        it 'should head 422' do
          post :create, params: person_params
          expect(response.status).to eq 422
        end

        it 'should return the errors' do
          post :create, params: person_params
          result = JSON.parse(response.body)
          expect(result).to be_a Hash
          expect(result.keys).to match_array ['errors']
          missing_entries = ['first_name']
          expect(result['errors'].keys).to match_array missing_entries
          missing_entries.each do |entry|
            expect(result['errors'][entry]).to match_array ['moet opgegeven zijn']
          end
        end

        it 'should render a 422 with errors if the role_id is not provided' do
          person_params = valid_person_params
          person_params.delete(:role)
          post :create, params: person_params
          expect(response.status).to eq 422

          result = JSON.parse(response.body)
          expect(result).to be_a Hash
          expect(result.keys).to match_array ['errors']
          missing_entries = ['role']

          expect(result['errors'].keys).to match_array missing_entries
          missing_entries.each do |entry|
            expect(result['errors'][entry]).to match_array ['is mandatory']
          end
        end
      end

      context 'valid person' do
        it 'should create a person' do
          pre_count = Person.count
          post :create, params: valid_person_params
          expect(Person.count).to eq pre_count + 1
        end

        it 'should head 201' do
          post :create, params: valid_person_params
          expect(response.status).to eq 201
        end

        it 'should return the person' do
          post :create, params: valid_person_params
          result = JSON.parse(response.body)
          expect(result).to be_a Hash
        end
      end
    end

    describe 'show' do
      it 'should call the correct serializer' do
        expect(controller).to receive(:render)
          .with(json: person, serializer: Api::PersonSerializer)
          .and_call_original
        get :me
      end

      it 'should render the correct json' do
        get :me
        expect(response.status).to eq 200
        expect(response.header['Content-Type']).to include 'application/json'
        json = JSON.parse(response.body)
        expect(json).to_not be_nil
        expect(json['first_name']).to eq person.first_name
        expect(json['last_name']).to eq person.last_name
        expect(json['mobile_phone']).to eq person.mobile_phone
        expect(json['gender']).to eq person.gender
        expect(json['email']).to eq person.email
        expect(json['iban']).to eq person.iban
      end
    end

    describe 'create' do
      let(:new_person) { FactoryBot.build(:person, role: student_role) }
      describe 'with a valid call' do
        before :each do
          # Reload is needed so PG can give it a uuid
          student_role.reload
        end

        it 'should head 201' do
          post :create, params: { person: new_person.attributes, role: { uuid: new_person.role.uuid } }
          expect(response.status).to eq 201
        end

        it 'should call the correct serializer' do
          expect(controller).to receive(:render)
            .with(json: kind_of(Person), serializer: Api::PersonSerializer, status: 201)
            .and_call_original
          post :create, params: { person: new_person.attributes, role: { uuid: new_person.role.uuid } }
        end

        it 'should return the created person json' do
          post :create, params: { person: new_person.attributes, role: { uuid: new_person.role.uuid } }
          expect(response.header['Content-Type']).to include 'application/json'

          json = JSON.parse(response.body)
          expect(json).to_not be_nil
          expect(json['first_name']).to eq new_person.first_name
          expect(json['last_name']).to eq new_person.last_name
          expect(json['mobile_phone']).to eq new_person.mobile_phone
          expect(json['gender']).to eq new_person.gender
          expect(json['iban']).to eq new_person.iban
        end
      end

      describe 'check_role_id_for_created_person filter' do
        it 'should check if the provided role is valid / allowed' do
          cookie_auth(person)
          mentor_role.reload
          new_person.role = mentor_role
          post :create, params: { person: new_person.attributes, role: { uuid: new_person.role.uuid } }
          expect(response.status).to eq 403
        end
      end
    end
  end
end
