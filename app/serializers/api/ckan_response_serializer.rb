# frozen_string_literal: true

module Api
  class CkanResponseSerializer < ActiveModel::Serializer

    attributes %i[dataset resource records schema]

    def dataset
      ENV['CKAN_DATASET']
    end

    def resource
      { name: questionnaire.name }
    end

    def schema
      { primaryKey: :uuid, columns: columns }
    end

    def records
      # flat_responses = flatten(object.values)
      # flat_responses.slice(*columns.pluck(:id).map(&:to_s))
      responses = object.values.slice(*columns.pluck(:id).map(&:to_s))
      responses[:uuid] = object.uuid
      [responses]
    end

    private

    def questionnaire
      object.measurement.questionnaire
    end

    def columns
      cols = [{ id: :uuid, type: :text }]
      # TODO: add external_user or some other non-identifiable person id so we can group responses by participant
      cols + flatten_questions(questionnaire.content[:questions]).map do |question|
        column = question.slice(:id)
        # TODO: map vsv types to ckan types
        column[:type] = :text
        column[:info] = { label: question[:title] }
        column
      end
    end

    # A questionnaire may contain nested questions. This method flattens them.
    # @param questions [Array] A questionnaire definition hash
    def flatten_questions(questions)
      questions.map do |question|
        next flatten_questions(question[:content]) if question[:type] == :expandable
        # Filter out raw questions, since they don't have an id
        # TODO: figure out how to deal with raw
        next if question[:type] == :raw

        question
      end.flatten.compact
    end
  end
end
