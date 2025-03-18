# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Instructor, '.class' do
  it 'returns the default mode after patching' do
    described_class.from_openai(OpenAI::Client)
    expect(Instructor::OpenAI.mode).to eq(:structured_output)
  end

  it 'changes the the mode to structured output' do
    described_class.from_openai(OpenAI::Client, mode: :structured_output)
    expect(Instructor::OpenAI.mode).to eq(:structured_output)
  end

  it 'changes the the mode to function calling' do
    described_class.from_openai(OpenAI::Client, mode: :function_calling)
    expect(Instructor::OpenAI.mode).to eq(:function_calling)
  end
end
