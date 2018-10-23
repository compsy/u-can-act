module Types
  class QuestionnaireType < GraphQL::Schema::Object
    description "A Questionnaire"
    field :id, ID, null: false
    field :key, String, null: false
    field :title, String, null: true
    field :name, String, null: false
  end
end
