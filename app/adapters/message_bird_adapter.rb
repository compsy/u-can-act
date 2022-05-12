# frozen_string_literal: true

class MessageBirdAdapter
  attr_reader :client, :test_mode

  def initialize(test_mode)
    @client = ::MessageBird::Client.new(ENV.fetch('MESSAGEBIRD_ACCESS_KEY', nil))
    @test_mode = test_mode
  end

  def send_text(from, recipient, body, reference: nil)
    if test_mode
      self.class.deliveries << { client: client, from: from, to: recipient, body: body, reference: reference }
    else
      client.message_create(from, recipient, body, reference: reference)
    end
  end

  def self.deliveries
    @deliveries ||= []
  end
end
