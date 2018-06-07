FactoryBot.define do
  factory :auth_user do
    auth0_id_string "MyString"
    password_digest "MyString"
    role "MyString"
    person nil
  end
end
