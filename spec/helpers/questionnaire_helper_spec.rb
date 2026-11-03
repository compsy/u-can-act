# frozen_string_literal: true

require 'rails_helper'

describe QuestionnaireHelper do
  describe 'get_registration_hash' do
    it 'escapes html in the answers' do
      result = helper.get_registration_hash('v1' => '<b>x</b>', 'v2' => "O'Neil", 'v3' => '&', 'v4' => '<i>f</i>',
                                            'v5' => '<u>a</u>', 'v6' => 'a@b.nl', 'v8_anders_namelijk' => 'true',
                                            'v8_anders_namelijk_text' => '<s>d</s>')
      expect(result).to include(first_name: '&lt;b&gt;x&lt;/b&gt;',
                                name: '&lt;b&gt;x&lt;/b&gt; O&#39;Neil &amp;',
                                function: '&lt;i&gt;f&lt;/i&gt;',
                                affiliation: '&lt;u&gt;a&lt;/u&gt;',
                                email_address: 'a@b.nl')
      expect(result[:diet]).to include('Anders: &lt;s&gt;d&lt;/s&gt;<br>')
    end
  end
end
