# frozen_string_literal: true

require 'ostruct'

module Instructor
  # This module defines constants related to different modes of operation.
  # It provides options for tool behavior, function types, and JSON modes.
  # Currently supported modes are:
  # - tools: select between function, auto, required, and none.
  # more modes will be added in the near future.
  module Mode
    STRUCTURED_OUTPUT = :structured_output
    FUNCTION_CALLING = :function_calling

    def self.structured_output?
      Instructor.mode == STRUCTURED_OUTPUT
    end

    def self.function_calling?
      Instructor.mode == FUNCTION_CALLING
    end
  end
end
