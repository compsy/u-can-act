# frozen_string_literal: true

module Api
  module V1
    module Admin
      class TestUsersController < ApiController

        {
          person: {
            type: 'mentor',
            students: 2
          },
          protocol: {
            id: 1,
            responses_completed: 3,
            responses_missed: 4,
            responses_future: 4 #Of which one is now, always.
          }
        }
        def create
          
        end
            
        private
            
        def create_random_person(type)
          first = random_name(5)
          last = random_name(5)
          loop do
            person = Person.build(first_name: first ,
                                  last_name: last,
                                  gender: random_gender,
                                  mobile_phone: random_mobile_phone,
                                  email: "#{first}.#{last}@u-can-act.nl",
                                  type: type)
            break if person.valid?
          end
          person.save!
        end

        def random_name(length = 5)
          (0...length).map { ('a'..'z').to_a[rand(26)] }.join
        end

        def random_gender(length = 5)
          [Person::MALE, Person::FEMALE].sample
        end

        def random_mobile_phone
          "#{06(0...8).map { rand(10) }.join}"
        end
      end
    end
  end
end
