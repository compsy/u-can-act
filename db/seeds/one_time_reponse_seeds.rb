# frozen_string_literal: true

OneTimeResponse.delete_all
protocol = Protocol.find_by_name('evaluatieonderzoek')
OneTimeResponse.create!(token: 'abc', protocol: protocol)
