# frozen_string_literal: true

require 'spec_helper'
require 'instructor/openai/mode'

RSpec.describe Instructor::OpenAI do
  # Reset the mode after each test to avoid test pollution
  after do
    described_class.mode = nil
  end

  describe '.mode and .mode=' do
    it 'allows setting and getting the mode' do
      described_class.mode = :test_mode
      expect(described_class.mode).to eq(:test_mode)
    end

    it 'returns structured output when mode is not set' do
      expect(described_class.mode).to eq(:structured_output)
    end
  end
end

RSpec.describe Instructor::OpenAI::Mode do
  # Reset the mode after each test to avoid test pollution
  after do
    Instructor::OpenAI.mode = nil
  end

  describe '.structured_output?' do
    it 'returns true when mode is set to STRUCTURED_OUTPUT' do
      Instructor::OpenAI.mode = Instructor::OpenAI::Mode::STRUCTURED_OUTPUT
      expect(described_class.structured_output?).to be true
    end

    it 'returns false when mode is set to something else' do
      Instructor::OpenAI.mode = Instructor::OpenAI::Mode::FUNCTION_CALLING
      expect(described_class.structured_output?).to be false
    end

    it 'returns true when mode is not set' do
      expect(described_class.structured_output?).to be true
    end
  end

  describe '.function_calling?' do
    it 'returns true when mode is set to FUNCTION_CALLING' do
      Instructor::OpenAI.mode = Instructor::OpenAI::Mode::FUNCTION_CALLING
      expect(described_class.function_calling?).to be true
    end

    it 'returns false when mode is set to something else' do
      Instructor::OpenAI.mode = Instructor::OpenAI::Mode::STRUCTURED_OUTPUT
      expect(described_class.function_calling?).to be false
    end

    it 'returns true when mode is not set' do
      expect(described_class.function_calling?).to be true
    end
  end

  describe 'constants' do
    it 'defines STRUCTURED_OUTPUT constant' do
      expect(described_class::STRUCTURED_OUTPUT).to eq(:structured_output)
    end

    it 'defines FUNCTION_CALLING constant' do
      expect(described_class::FUNCTION_CALLING).to eq(:function_calling)
    end
  end
end
