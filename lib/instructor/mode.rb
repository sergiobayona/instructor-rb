# frozen_string_literal: true

module Instructor
  # This module defines constants related to different modes of operation.
  # It provides options for tool behavior, function types, and JSON modes.
  # Currently supported modes are:
  # - tools: select between function, auto, required, and none.
  # more modes will be added in the near future.
  module Mode
    STRUCTURED_OUTPUT = :structured_output
    FUNCTION_CALLING = :function_calling
    TOOLS = %i[function auto required none].index_by(&:itself)
    DEFAULT_TOOL_CHOICE = TOOLS[:function]

    def self.structured_output?
      Instructor.mode == STRUCTURED_OUTPUT
    end

    def self.function_calling?
      Instructor.mode == FUNCTION_CALLING
    end

    def self.mode
      Instructor.mode
    end
  end
end
