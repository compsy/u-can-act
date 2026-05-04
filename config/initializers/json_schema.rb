# frozen_string_literal: true

# json-schema is a transient dependency coming from rswag. Rswag is only
# available on the development and test environments. If we run this initializer
# on production we get a boot fail. We could just skip it on production, but
# actually checking for the presence of the gem is more correct.
return unless Gem.loaded_specs.key?('json-schema')

require 'json-schema'

# multi_json has been deprecated
JSON::Validator.use_multi_json = false
