# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SupervisedPersonController do
  let(:team) { FactoryBot.create(:team) }
  let(:mentor_role) { FactoryBot.create(:role, :mentor, team: team) }
  let(:student_role) { FactoryBot.create(:role, :student, team: team) }
  let(:person) { FactoryBot.create(:person, :with_iban, role: mentor_role, email: 'test@test2.com') }

  let!(:mentor_protocol) { FactoryBot.create(:protocol) }
  let!(:student_protocol) { FactoryBot.create(:protocol) }
  let!(:supervision_trajectory) do
    FactoryBot.create(:supervision_trajectory,
                      protocol_for_mentor: mentor_protocol,
                      protocol_for_student: student_protocol)
  end

  let(:new_person) { FactoryBot.build(:person, role: student_role) }
  let!(:params) do
    { person: new_person.attributes,
      role: { uuid: new_person.role.uuid },
      protocol: {
        start_date: '2018-08-23',
        end_date: '2019-05-16'
      },
      supervision_trajectory: {
        uuid: supervision_trajectory.uuid
      } }
  end

  it_should_behave_like 'an is_logged_in_as_mentor concern', 'post', :create

  describe 'without authentication' do
    it 'should head 401' do
      post :create
      expect(response.status).to eq 401
    end
  end

  describe 'with authentication' do
    before :each do
      cookie_auth(person)
    end

    describe 'create' do
      before :each do
        student_role.reload
        supervision_trajectory.reload
        Timecop.freeze(2018, 7, 1)
      end

      after :each do
        Timecop.return
      end
      describe 'succes' do
        it 'should head 201 when the person is created' do
          post :create, params: {
            person: new_person.attributes,
            role: { uuid: new_person.role.uuid },
            protocol: {
              start_date: '2018-08-23',
              end_date: '2019-05-16'
            },
            supervision_trajectory: {
              uuid: supervision_trajectory.uuid
            }
          }
          expect(response.status).to eq 201
        end

        it 'should return the created person' do
          post :create, params: {
            person: new_person.attributes,
            role: { uuid: new_person.role.uuid },
            protocol: {
              start_date: '2018-08-23',
              end_date: '2019-05-16'
            },
            supervision_trajectory: {
              uuid: supervision_trajectory.uuid
            }
          }
          expect(response.header['Content-Type']).to include 'application/json'
          json = JSON.parse(response.body)
          expect(json).to_not be_nil
          expect(json['first_name']).to eq new_person.first_name
          expect(json['last_name']).to eq new_person.last_name
          expect(json['mobile_phone']).to eq new_person.mobile_phone
          expect(json['gender']).to eq new_person.gender
          expect(json['iban']).to eq new_person.iban
        end

        it 'should use the correct serializer' do
          expect(controller).to receive(:render)
            .with(json: kind_of(Person), serializer: Api::PersonSerializer, status: 201)
            .and_call_original
          post :create, params: {
            person: new_person.attributes,
            role: { uuid: new_person.role.uuid },
            protocol: {
              start_date: '2018-08-23',
              end_date: '2019-05-16'
            },
            supervision_trajectory: {
              uuid: supervision_trajectory.uuid
            }
          }
        end

        it 'should actually create and save the person + subscriptions' do
          pre_person_count = Person.count
          pre_protocol_count = ProtocolSubscription.count
          pre_mentor_protocol_count = person.protocol_subscriptions.count
          post :create, params: {
            person: new_person.attributes,
            role: { uuid: new_person.role.uuid },
            protocol: {
              start_date: '2018-08-23',
              end_date: '2019-05-16'
            },
            supervision_trajectory: {
              uuid: supervision_trajectory.uuid
            }
          }
          expect(response.status).to eq 201
          expect(Person.count).to eq pre_person_count + 1
          expect(person.protocol_subscriptions.count).to eq pre_mentor_protocol_count + 1
          expect(ProtocolSubscription.count).to eq pre_protocol_count + 2
        end
        it 'should start the protocol subscriptions at the correct dates' do
          post :create, params: {
            person: new_person.attributes,
            role: { uuid: new_person.role.uuid },
            protocol: {
              start_date: '2018-08-23',
              end_date: '2019-05-16'
            },
            supervision_trajectory: {
              uuid: supervision_trajectory.uuid
            }
          }
          new_prot_subs = ProtocolSubscription.last(2)
          new_prot_subs.each do |sub|
            expect(sub.start_date).to eq Time.new(2018, 8, 20)
            expect(sub.end_date).to eq Time.new(2019, 5, 13)
          end
        end
      end

      describe 'unsuccessful' do
        it 'should not store the person if the subscription fails' do
          pre_count = Person.count
          expect_any_instance_of(SupervisionTrajectory)
            .to receive(:subscribe!)
            .and_raise('raising!')
          expect do
            post :create, params: {
              person: new_person.attributes,
              role: { uuid: new_person.role.uuid },
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              supervision_trajectory: {
                uuid: supervision_trajectory.uuid
              }
            }
          end.to raise_error RuntimeError, 'raising!'
          expect(Person.count).to eq pre_count
        end

        describe 'roles' do
          it 'should head 422 if the role is missing' do
            post :create, params: {
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              person: new_person.attributes,
              supervision_trajectory: {
                uuid: supervision_trajectory.uuid
              }
            }
            result = JSON.parse(response.body)
            expect(response.status).to eq 422
            expect(result.keys).to eq ['errors']
            expect(result['errors'].keys).to eq ['role']
            expect(result['errors']['role']).to eq ['is mandatory']
          end

          it 'should head 422 if the provided role is not found' do
            post :create, params: {
              person: new_person.attributes,
              role: { uuid: 'unknownrole' },
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              supervision_trajectory: {
                uuid: supervision_trajectory.uuid
              }
            }
            result = JSON.parse(response.body)
            expect(response.status).to eq 422
            expect(result.keys).to eq ['errors']
            expect(result['errors'].keys).to eq ['role_uuid']
            expect(result['errors']['role_uuid']).to eq ['not found']
          end

          it 'should check if the provided role is valid / allowed' do
            cookie_auth(person)
            mentor_role.reload
            new_person.role = mentor_role
            post :create, params: {
              person: new_person.attributes,
              role: { uuid: new_person.role.uuid },
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              supervision_trajectory: {
                uuid: supervision_trajectory.uuid
              }
            }
            expect(response.status).to eq 403
          end
        end

        describe 'supervision trajectory' do
          it 'should head 422 if the supervision trajectory is missing' do
            post :create, params: {
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              person: new_person.attributes,
              role: { uuid: new_person.role.uuid }
            }
            result = JSON.parse(response.body)
            expect(response.status).to eq 422
            expect(result.keys).to eq ['errors']
            expect(result['errors'].keys).to eq ['supervision_trajectory']
            expect(result['errors']['supervision_trajectory']).to eq ['is mandatory']
          end

          it 'should head 422 if the provided supervision trajectory is not found' do
            post :create, params: {
              person: new_person.attributes,
              role: { uuid: new_person.role.uuid },
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              supervision_trajectory: {
                uuid: 'something incorrect'
              }
            }
            result = JSON.parse(response.body)
            expect(response.status).to eq 422
            expect(result.keys).to eq ['errors']
            expect(result['errors'].keys).to eq ['supervision_trajectory_uuid']
            expect(result['errors']['supervision_trajectory_uuid']).to eq ['not found']
          end
        end

        describe 'protocol' do
          describe 'start date' do
            it 'should head 422 if the provided start_date is incorrect' do
              post :create, params: {
                person: new_person.attributes,
                role: { uuid: new_person.role.uuid },
                protocol: {
                  end_date: '2019-05-16',
                  start_date: 'not a date!'
                },
                supervision_trajectory: {
                  uuid: supervision_trajectory.uuid
                }
              }
              result = JSON.parse(response.body)
              expect(response.status).to eq 422
              expect(result.keys).to eq ['errors']
              expect(result['errors'].keys).to eq ['start_date']
              expect(result['errors']['start_date']).to eq ['invalid date']
            end

            it 'should head 422 if the provided start_date is missing' do
              post :create, params: {
                person: new_person.attributes,
                role: { uuid: new_person.role.uuid },
                protocol: {
                  end_date: '2019-05-16'
                },
                supervision_trajectory: {
                  uuid: supervision_trajectory.uuid
                }
              }
              result = JSON.parse(response.body)
              expect(response.status).to eq 422
              expect(result.keys).to eq ['errors']
              expect(result['errors'].keys).to eq ['start_date']
              expect(result['errors']['start_date']).to eq ['incorrect or missing']
            end
          end

          describe 'end date' do
            it 'should head 422 if the provided end_date is incorrect' do
              post :create, params: {
                person: new_person.attributes,
                role: { uuid: new_person.role.uuid },
                protocol: {
                  start_date: '2019-05-16',
                  end_date: 'not a date!'
                },
                supervision_trajectory: {
                  uuid: supervision_trajectory.uuid
                }
              }
              result = JSON.parse(response.body)
              expect(response.status).to eq 422
              expect(result.keys).to eq ['errors']
              expect(result['errors'].keys).to eq ['end_date']
              expect(result['errors']['end_date']).to eq ['invalid date']
            end

            it 'should head 422 if the provided end_date is missing' do
              post :create, params: {
                person: new_person.attributes,
                role: { uuid: new_person.role.uuid },
                protocol: {
                  start_date: '2019-05-16'
                },
                supervision_trajectory: {
                  uuid: supervision_trajectory.uuid
                }
              }
              result = JSON.parse(response.body)
              expect(response.status).to eq 422
              expect(result.keys).to eq ['errors']
              expect(result['errors'].keys).to eq ['end_date']
              expect(result['errors']['end_date']).to eq ['incorrect or missing']
            end
          end
        end

        describe 'person params' do
          it 'should head 422 if no person object is provided' do
            post :create, params: {
              role: { uuid: new_person.role.uuid },
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              supervision_trajectory: {
                uuid: supervision_trajectory.uuid
              }
            }
            result = JSON.parse(response.body)
            expect(response.status).to eq 422
            expect(result.keys).to eq ['errors']
            expect(result['errors'].keys).to eq ['person']
            expect(result['errors']['person']).to eq ['is mandatory']
          end

          it 'should head 422 if no first name is provided' do
            attr = new_person.attributes
            attr.delete('first_name')
            post :create, params: {
              person: attr,
              role: { uuid: new_person.role.uuid },
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              supervision_trajectory: {
                uuid: supervision_trajectory.uuid
              }
            }
            result = JSON.parse(response.body)
            expect(response.status).to eq 422
            expect(result.keys).to eq ['errors']
            expect(result['errors'].keys).to eq ['first_name']
            expect(result['errors']['first_name']).to eq ['not found']
          end

          it 'should head 422 if no last name is provided' do
            attr = new_person.attributes
            attr.delete('last_name')
            post :create, params: {
              person: attr,
              role: { uuid: new_person.role.uuid },
              protocol: {
                start_date: '2018-08-23',
                end_date: '2019-05-16'
              },
              supervision_trajectory: {
                uuid: supervision_trajectory.uuid
              }
            }
            result = JSON.parse(response.body)
            expect(response.status).to eq 422
            expect(result.keys).to eq ['errors']
            expect(result['errors'].keys).to eq ['last_name']
            expect(result['errors']['last_name']).to eq ['not found']
          end
        end
      end
    end
  end
end
