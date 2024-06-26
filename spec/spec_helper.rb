# frozen_string_literal: true

require 'instructor'
require 'pry-byebug'
require 'vcr'
require 'rspec/json_expectations'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<OPENAI_KEY_PLACEHOLDER>') { ENV.fetch('OPENAI_API_KEY', 'XXXXX') }
  config.filter_sensitive_data('<ANTHROPIC_KEY_PLACEHOLDER>') { ENV.fetch('ANTHROPIC_API_KEY', 'XXXXX') }
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

OpenAI.configure do |config|
  config.access_token = ENV.fetch('OPENAI_API_KEY', 'XXXXX')
end

Anthropic.configure do |config|
  config.access_token = ENV.fetch('ANTHROPIC_API_KEY', 'XXXXX')
end
