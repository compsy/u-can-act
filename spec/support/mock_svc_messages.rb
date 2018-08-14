# frozen_string_literal: true

module MockSvcMessages
  def mock_svc_messages
    response = double('repsonse')
    mock_result = ::Compsy::MicroserviceApi::Models::Result.new
    mock_result.response = {
      'result' => {
        'payload' => 'mock message!'
      }
    }
    allow(response)
      .to receive(:parsed_response)
      .and_return(response)

    allow(response)
      .to receive(:to_hash)
      .and_return(mock_result.to_hash)

    allow(response)
      .to receive(:code)
      .and_return(200)
    allow_any_instance_of(::Compsy::MicroserviceApi::Sessions::BasicAuthSession)
      .to receive(:post)
      .and_return response
  end
end
