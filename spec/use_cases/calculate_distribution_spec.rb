# frozen_string_literal: true

require 'rails_helper'

describe CalculateDistribution do
  describe 'execute' do
    let(:questionnaire) { FactoryBot.create(:questionnaire) }

    it 'should store the correct results' do
      questionnaire.content[:questions][3] = {
        id: :v4,
        type: :date,
        title: 'Wanneer ben je gestopt?'
      }
      questionnaire.save!
      measurement = FactoryBot.create(:measurement, questionnaire: questionnaire)
      reponse_content = FactoryBot.create(:response_content, content: {
                                            'v2_brood' => 'true',
                                            'v3' => '68',
                                            'v4' => '2019-06-02'
                                          })
      response_obj = FactoryBot.create(:response, :completed, measurement: measurement)
      response_obj.content = reponse_content.id
      response_obj.save!
      expected = {
        'total' => 1,
        'v3' => {
          '_min' => 0,
          '_max' => 100,
          '_step' => 1,
          '68' => { '_' => 1 }
        },
        'v4' => {
          '2019' => {
            '_' => 1,
            '6' => {
              '_' => 1,
              '2' => { '_' => 1 }
            }
          }
        },
        'v2_brood' => {
          'true' => { '_' => 1 }
        }
      }
      expect(RedisService).to receive(:set).with("distribution_#{response_obj.measurement.questionnaire.key}",
                                                 expected.to_json)
      expect(described_class.run!(questionnaire: response_obj.measurement.questionnaire))
    end
  end
end
