module Types
  class QueryType < GraphQL::Schema::Object
    description "The query root of this schema"

    # First describe the field signature:
    field :questionnaire, QuestionnaireType, null: true do
      description "Find a questionnaire by key"
      argument :key, String, required: true
    end

    field :questionnaire, [QuestionnaireType], null: true do
      description "Return all questionnaires"
    end

    # Then provide an implementation:
    def questionnaire(key:)
      Questionnaire.find_by_key(key)
    end

    def questionnaire
      Questionnaire.all
    end
  end
end
