# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'an object_exporter object' do
  let(:klass_instance) { FactoryBot.create(described_class.klass.to_s.underscore.to_sym) }

  describe 'inheritance' do
    it 'is an ObjectExporter' do
      expect(described_class).to be < ObjectExporter
    end
  end

  describe 'klass' do
    it 'is implemented' do
      expect do
        described_class.klass
      end.not_to raise_error
    end
    it 'returns a class' do
      expect(described_class.class).to eq Class
    end
  end

  describe 'default_fields' do
    it 'is implemented' do
      expect do
        described_class.default_fields
      end.not_to raise_error
    end
    it 'returns an array of strings' do
      expect(described_class.default_fields.class).to eq Array
      described_class.default_fields.each do |field|
        expect(field.class).to eq String
      end
    end
    it 'returns valid klass model properties' do
      described_class.default_fields.each do |field|
        expect do
          klass_instance.send(field.to_sym)
        end.not_to raise_error
      end
    end
  end

  describe 'formatted_fields' do
    it 'is implemented' do
      expect do
        described_class.formatted_fields
      end.not_to raise_error
    end
    it 'returns an array of strings' do
      expect(described_class.formatted_fields.class).to eq Array
      described_class.formatted_fields.each do |field|
        expect(field.class).to eq String
      end
    end
  end

  describe 'format_fields(klass_instance)' do
    it 'is implemented' do
      expect do
        described_class.format_fields(klass_instance)
      end.not_to raise_error
    end
    it 'returns a hash with <string,string|int|nil> tuples' do
      expect(described_class.format_fields(klass_instance).class).to eq Hash
      described_class.format_fields(klass_instance).each do |key, value|
        expect(key.class).to eq String
        expect([String, Integer, NilClass]).to include(value.class)
      end
    end
    it 'returns a hash with the same keys as the formatted_fields method' do
      expected = described_class.formatted_fields.sort
      expect(described_class.format_fields(klass_instance).keys.sort).to eq expected
    end
  end

  describe 'to_be_skipped?(klass_instance)' do
    it 'is implemented' do
      expect do
        described_class.to_be_skipped?(klass_instance)
      end.not_to raise_error
    end
    it 'returns a boolean' do
      expect([true, false]).to include(described_class.to_be_skipped?(klass_instance))
    end
  end
end
