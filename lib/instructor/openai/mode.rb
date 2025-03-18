# frozen_string_literal: true

module Instructor
  # This module defines constants related to different modes of operation for the OpenAI api.
  # It provides options for tool behavior, function types, and JSON modes.
  # Currently supported modes are:
  # - tools: select between function, auto, required, and none.
  module OpenAI
    def self.mode=(mode)
      @mode = mode
    end

    def self.mode
      @mode ||= Mode::STRUCTURED_OUTPUT
    end

    module Mode
      STRUCTURED_OUTPUT = :structured_output
      FUNCTION_CALLING = :function_calling

      def self.structured_output?
        Instructor::OpenAI.mode == STRUCTURED_OUTPUT
      end

      def self.function_calling?
        Instructor::OpenAI.mode == FUNCTION_CALLING
      end
    end
  end
end
