# frozen_string_literal: true

require 'rails_helper'

describe ObjectExporter do
  describe 'export_lines' do
    it 'should call export with the correct parameters' do
      expect(described_class).to receive(:klass).and_return(1)
      expect(described_class).to receive(:formatted_fields).and_return(2)
      expect(described_class).to receive(:default_fields).and_return(3)
      expect(described_class).to receive(:export).with(1, 2, 3)
      described_class.export_lines.to_a
    end
    it 'should encode the exported string' do
      str = double('string')
      expect(str).to receive(:encode)
        .with('ISO-8859-1', 'UTF-8', invalid: :replace, undef: :replace)
        .and_return('hoi')
      expect(described_class).to receive(:klass).and_return(1)
      expect(described_class).to receive(:formatted_fields).and_return(2)
      expect(described_class).to receive(:default_fields).and_return(3)
      expect(described_class).to receive(:export).and_yield(str)
      expect(described_class.export_lines.to_a).to eq(["hoi\n"])
    end
  end

  describe 'klass' do
    it 'should raise an error' do
      expect do
        described_class.klass
      end.to raise_error(RuntimeError, 'klass not implemented by subclass!')
    end
  end

  describe 'default_fields' do
    it 'should raise an error' do
      expect do
        described_class.default_fields
      end.to raise_error(RuntimeError, 'default_fields not implemented by subclass!')
    end
  end

  describe 'formatted_fields' do
    it 'should raise an error' do
      expect do
        described_class.formatted_fields
      end.to raise_error(RuntimeError, 'formatted_fields not implemented by subclass!')
    end
  end

  describe 'format_fields' do
    it 'should raise an error' do
      expect do
        described_class.format_fields(nil)
      end.to raise_error(RuntimeError, 'format_fields(klass_instance) not implemented by subclass!')
    end
  end

  describe 'to_be_skipped?' do
    it 'should raise an error' do
      expect do
        described_class.to_be_skipped?(nil)
      end.to raise_error(RuntimeError, 'to_be_skipped?(klass_instance) not implemented by subclass!')
    end
  end
end
