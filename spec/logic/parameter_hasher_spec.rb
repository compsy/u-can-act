# frozen_string_literal: true

require 'rails_helper'

describe ParameterHasher do
  let(:params_arr) { %i[some_param another_param a_third_param] }
  let(:params_hsh) do
    {
      some_param: 'hello value',
      another_param: 'some other value',
      a_third_param: 'yet another value'
    }
  end
  let(:shared_secret) { 'my_shared_secret' }

  describe '#generate_hmac' do
    it 'should generate the correct result' do
      expected = Digest::SHA256.hexdigest([shared_secret,
                                           params_hsh[:some_param],
                                           params_hsh[:another_param],
                                           params_hsh[:a_third_param]].join('|'))
      result = described_class.generate_hmac(params_arr, params_hsh, shared_secret)
      expect(result).to eq expected
    end

    it 'should work when there are other params in the hash' do
      params_hsh[:yet_something_else] = 'hello there'
      params_hsh[:more_stuff_here] = 'where'
      expected = Digest::SHA256.hexdigest([shared_secret,
                                           params_hsh[:some_param],
                                           params_hsh[:another_param],
                                           params_hsh[:a_third_param]].join('|'))
      result = described_class.generate_hmac(params_arr, params_hsh, shared_secret)
      expect(result).to eq expected
    end
    it 'should respect the order of the given params arr' do
      params_arr = %i[another_param some_param a_third_param]
      expected = Digest::SHA256.hexdigest([shared_secret,
                                           params_hsh[:another_param],
                                           params_hsh[:some_param],
                                           params_hsh[:a_third_param]].join('|'))
      result = described_class.generate_hmac(params_arr, params_hsh, shared_secret)
      expect(result).to eq expected
    end
  end
  describe '#generate_hmac_params' do
    it 'should call generate_hmac with the given parameters' do
      params_hsh[:param_param] = 'hi there'
      expect(ParameterHasher).to receive(:generate_hmac).with(params_arr,
                                                              params_hsh,
                                                              shared_secret).and_return('negen')
      expected = { some_param: 'hello value',
                   another_param: 'some other value',
                   a_third_param: 'yet another value',
                   param_param: 'hi there',
                   hmac: 'negen' }
      result = described_class.generate_hmac_params(params_arr, params_hsh, shared_secret)
      expect(result).to eq expected
    end
    it 'should add the correct hmac param to the given hash' do
      expected_hmac = Digest::SHA256.hexdigest([shared_secret,
                                                params_hsh[:some_param],
                                                params_hsh[:another_param],
                                                params_hsh[:a_third_param]].join('|'))
      expected = { some_param: 'hello value',
                   another_param: 'some other value',
                   a_third_param: 'yet another value',
                   hmac: expected_hmac }
      result = described_class.generate_hmac_params(params_arr, params_hsh, shared_secret)
      expect(result).to eq expected
    end
    it 'should overwrite an existing hmac param' do
      expected_hmac = Digest::SHA256.hexdigest([shared_secret,
                                                params_hsh[:some_param],
                                                params_hsh[:another_param],
                                                params_hsh[:a_third_param]].join('|'))
      expected = { some_param: 'hello value',
                   another_param: 'some other value',
                   a_third_param: 'yet another value',
                   hmac: expected_hmac }
      params_hsh[:hmac] = 'eleven'
      expect(params_hsh[:hmac]).to eq 'eleven'
      result = described_class.generate_hmac_params(params_arr, params_hsh, shared_secret)
      expect(result).to eq expected
    end
  end
  describe '#valid_hmac_params?' do
    it 'returns false when no hmac param is present' do
      result = described_class.valid_hmac_params?(params_arr, params_hsh, shared_secret)
      expect(result).to be_falsey
    end
    it 'returns false when the given hmac param is incorrect' do
      params_hsh[:hmac] = 'thirteen'
      result = described_class.valid_hmac_params?(params_arr, params_hsh, shared_secret)
      expect(result).to be_falsey
    end
    it 'returns true if everything is correct' do
      expected_hmac = Digest::SHA256.hexdigest([shared_secret,
                                                params_hsh[:some_param],
                                                params_hsh[:another_param],
                                                params_hsh[:a_third_param]].join('|'))
      hmac_params_hsh = { some_param: 'hello value',
                          another_param: 'some other value',
                          a_third_param: 'yet another value',
                          hmac: expected_hmac }
      result = described_class.valid_hmac_params?(params_arr, hmac_params_hsh, shared_secret)
      expect(result).to be_truthy
    end
    it 'returns true when called with its own result' do
      hmac_params_hsh = described_class.generate_hmac_params(params_arr, params_hsh, shared_secret)
      result = described_class.valid_hmac_params?(params_arr, hmac_params_hsh, shared_secret)
      expect(result).to be_truthy
    end
  end
end
