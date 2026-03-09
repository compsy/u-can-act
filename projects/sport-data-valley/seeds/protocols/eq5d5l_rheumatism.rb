# frozen_string_literal: true

require_relative '../questionnaires/eq5d5l_rheumatism'
require_relative 'rheumatism_standalone_protocol_helper'

create_or_update_rheumatism_standalone_protocol(File.basename(__FILE__)[0...-3])
