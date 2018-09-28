# frozen_string_literal: true

OneTimeResponse.delete_all
OneTimeResponse.create!(token: 'abc', protocol: Protocol.first)
