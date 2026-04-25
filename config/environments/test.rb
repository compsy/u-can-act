# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

# Uncomment this to make jwt-api specs work if you have an .env.local file for sport-data-valley.
# ENV['TOKEN_SIGNATURE_ALGORITHM'] = 'RS256'
# ENV['AUTH0_CLIENT_ID'] = 'CCMYoMGi6mApMRFdnqpAHFtjeFceFGPr'
# ENV['AUTH0_DOMAIN'] = 'ikia-development.eu.auth0.com'
# ENV['AUTH0_CLIENT_SECRET'] = '-opwFYMuXOWCvDzTpRmVrEkPqTvSD4dZps0u2RMZpSwmEfmLmoj20DVdEDUOnZwt'
# ENV['AUTH0_REDIRECT_URL'] = 'http://localhost:3002/admin/callback'
# ENV['AUTH0_AUDIENCE'] = 'https://ikia-development.eu.auth0.com/api/v2/'

ENV['PRIVATE_KEY'] = 'LS0tLS1CRUdJTiBFTkNSWVBURUQgUFJJVkFURSBLRVktLS0tLQpNSUlGSHpCSkJna3Foa2lHOXcwQkJRMHdQREFiQmdrcWhraUc5dzBCQlF3d0RnUUkwYVJQTDNZYVJtRUNBZ2dBCk1CMEdDV0NHU0FGbEF3UUJLZ1FRdXFrWVZpaEJidHAwSTU1M2wwazRud1NDQk5ETVkvSVpCUlFVdWpFTWpvVnoKU0ZuOWNyb2xFYWhCRE41U1E4dFk0WmZHQklWV2VoZXAyLzdzdkJNUjk3Z2FWYW5GNG9EU1BNblczOGtKSHZOZQo1M01LZkNFU3FRNmJWZm9DZzZ1cXgrMGNPSFF3cGZqMU1WY3BCRnFZSnVVcEViZXp0MThmakcybHN5cnRBNG9hCk15QVM3Ky85M2Z0OU5QczhEc3Q4TDdHK0R3eWJIdjYraTAvRmY2L0tGbVRubU5FQWV6Q1RHWm9mbjNFQkRhbWQKMkY3K0llRVoyZTQ2L2xrVTJaVlU0S0dta3Fta1JoeWdUZlFwMjZ0RXNkUnZFenRROEZmMWUrNzRtT1dQbHUrZgpZVzBWb0pGSDNNV21hYVBKNG9TaE9ja1V5K3d3T245bTZoTDd4OW5OZVA0S3ZKTXNPZU5CT2M1dTN1N1F2dTlmClN3OW5MOUJ6QWxNRktsYVZZSlV0STZrL0VEYUx4QVJVQ3k0WjR4S2RTUXc3WVZpSVJJdi9lVkNFc1p2WHp4bGsKanlNMDZPb1huc0dyai9Mb1JPSWNZN1IyOEN1V2RJZ283OG9IU2RqY0lNQk1qbU44VDB4UHdyMTlnbnFlWmErUAovUCtLT240QWZTbENscVo4SGNMa0Vua0tOTW5nN2hiTytCT1RuU3dXRVF5eUFLdzhmVy96cndLMWowUDRtdStFCjROYU5lQTk3c0VIc2RBYkdmZ3R3MUttZXViMHZ4S3R3VXdpdE9ZU2lDVWoxZlVRdjB3cEFobXJWYmREMVB6TnAKOGZhRjZYMDFWeDNTQXN6UEdMQWZPb0ZTSWRWU0NFWHZkL09MUXdHWUxKMm5rT2o5eUFacCtYa0djSllRa3RTdwo4T0FFOTFNNVhkbVhiUkFDU0I2VmtpWGk0RzJaQW1YbnNqVjdqaUZMdG5zNFlBRTZxeWwvUU0xanZqWjZVNGtMCldVRnZrN1h3WVNQV3lLR0laQnhqbmpPSFIyRmVrUS9yY0N0SDBJQWRoZlFEWXhtV2ROMlNnU3JYTHB3a2xvWEkKU3BvajZaaG1SZ0ZhZld0cTNUeFoxT3hzeXpPbmxDNVhseURBMFhSdVErWnMyTW9QaUdSYzJIUXh6UVU1eThKSgpFbXRPaklSL3JxL3ZBejZZV0NQcXU2WVY0cmozekthZEl0WTlGalFJWjRBYjQ0SkpFeks5NkxoRmg3dnQrWFdXCllRYTI2RFZINmdRcFBrblRXVUdlTUxqcElvMWJYWWcwdEJVOXRJZTlNay8rbCtoakRJUnc4ckNFc3VaMkFla1QKbnlhN1pkZEw2SFFJVzdzYkZQT3VlWmU1WnBoL29TSGk2MmF6aHZVT1Nna1VOdFdRSENIaGJ1OThTWFdwYW91OQpIcHFERlArRUsyL2pqOXBSeFdnUmxMK2lOYkZja1dpY3FnMHZkVzdHN2p3cEVUcW55OEppMmNxdW1yOFFMRWJBCmJVTTc4SG1GalJxa0tRSkRYVlZnTjlIbzJ3Wk93b1huem5LSHRyUHE5RmpVc3lxTi9XV3p3c0l1bVQ3ditZS3IKMW5uUGVoMDZETXlzODlMTVdaRFN1S05YeVVpZ0p0SERDaUF2TjNlOFN1QytzVnlsU0JrT2I0QnI5V1RkcEVKUApXTHpKQkFnK0MvY2ZNdndZbHBnUk54MHBteWcxdThiUWRFVHBWbXM2bE93V1BsOW1KbEtRWXZUTy9CY0t0SEtMCkNIbGxLNU5zQkN5N1d1cmpzN1B3ZzRoQ0M1UzVKUnp4L0lIMDdqY3QrVWc0MDJIWHIzNzZEcEhLbkQ2OHJ2ZUUKbEd4UlBEbUtyWWIrRnJMeCtCWER4ZmRXZnZsNENWVUdHN0VqeG5ONFM4QzFNZElrWmFHQW9IUWU1YVMvZmowbQppVGNuMWQ0Ty85ajRnc2JuNTB3MS9IdGRFV0hmTDlpcDJrY25GdDBlYnZCeTV2OVJDVVJXajZNOGNnWEpWeHI1Cnhzc1hBb3QrZnF0ZHAxd0l6SXZPd2xFRFJDTDUyY2Uvb2V6SDdKR0pxWGZMTXBpbk1IMFpoMnc1dWxMNCt5N0EKb2hwTWptNmlUSnZqUlVjeFQ0aXJtOHorUENub0s1YzNPakFKbGZGejZHajY1OEh6aXF2aFExc2VNbVM5Y0tqcwppZTZhRWNNVzBzdTNHdHhsejJyUUNDb0Rodz09Ci0tLS0tRU5EIEVOQ1JZUFRFRCBQUklWQVRFIEtFWS0tLS0tCg=='

ENV['PRIVATE_KEY_PASSPHRASE'] = 'ucanact'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false
  config.action_view.cache_template_loading = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = :none

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true
  config.action_mailer.default_url_options = {
    host: ENV.fetch('HOST_DOMAIN', nil),
    protocol: 'http',
    domain: ENV.fetch('HOST_DOMAIN', nil)
  }

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true
end
