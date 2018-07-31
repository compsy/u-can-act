# frozen_string_literal: true

# rubocop:disable HandleExceptions
begin
  require 'rails'
  module I18n
    class Railtie < ::Rails::Railtie #:nodoc:
      initializer 'rails-i18n' do |_app|
        I18n.load_path << Dir[File.join(File.expand_path(File.dirname(__FILE__) + '/../../config/locales'), '*.yml')]
        I18n.load_path.flatten!
      end
    end
  end
rescue LoadError
  # No I18n is set up as rails is not installed
end
# rubocop:enable HandleExceptions
