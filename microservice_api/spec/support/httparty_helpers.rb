# frozen_string_literal: true

def httparty_response(response_data)
  allow(response_data).to receive(:code).and_return 200
  allow(response_data).to receive(:parsed_response).and_return response_data
  response_data
end
