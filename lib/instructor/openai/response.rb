# frozen_string_literal: true

module Instructor
  module OpenAI
    module Response
      # Factory method to create the appropriate response type based on the mode
      #
      # @param response [Hash] The response received from the OpenAI API
      # @return [ToolResponse, StructuredResponse] The appropriate response object
      def self.create(response)
        if Instructor::Mode.structured_output?
          StructuredResponse.new(response)
        else
          ToolResponse.new(response)
        end
      end

      # The ToolResponse class represents the response received from the OpenAI API
      # when using function calling mode. It takes the raw response and provides
      # convenience methods to access the chat completions, tool calls, function
      # responses, and parsed arguments.
      class ToolResponse
        # Initializes a new instance of the ToolResponse class.
        #
        # @param response [Hash] The response received from the OpenAI API.
        def initialize(response)
          @response = response
        end

        # Returns the chat completions from the response.
        #
        # @return [Array] An array of chat completions.
        def chat_completions
          @response['choices']
        end

        # Returns the tool calls from the chat completions.
        #
        # @return [Hash, nil] The tool calls or nil if not found.
        def tool_calls
          chat_completions&.dig(0, 'message', 'tool_calls')
        end

        # Returns the function responses from the tool calls.
        #
        # @return [Array, nil] An array of function responses or nil if not found.
        def function_responses
          tool_calls&.map { |tool_call| tool_call['function'] }
        end

        # Returns the first function response.
        #
        # @return [Hash, nil] The first function response or nil if not found.
        def function_response
          function_responses&.first
        end

        # Checks if there is only a single function response.
        #
        # @return [Boolean] True if there is only a single function response, false otherwise.
        def single_response?
          function_responses&.size == 1
        end

        # Parses the function response(s) and returns the parsed arguments.
        #
        # @return [Array, Hash] The parsed arguments.
        def parse
          if single_response?
            JSON.parse(function_response['arguments'])
          else
            function_responses.map { |res| JSON.parse(res['arguments']) }
          end
        end

        # Returns the arguments of the function with the specified name.
        #
        # @param function_name [String] The name of the function.
        # @return [Hash, nil] The arguments of the function or nil if not found.
        def by_function_name(function_name)
          function_responses&.find { |res| res['name'] == function_name }&.dig('arguments')
        end
      end

      # The StructuredResponse class represents the response received from the OpenAI API
      # when using structured output mode. It takes the raw response and provides
      # convenience methods to access the chat completions and parse the JSON content.
      class StructuredResponse
        # Initializes a new instance of the StructuredResponse class.
        #
        # @param response [Hash] The response received from the OpenAI API.
        def initialize(response)
          @response = response
        end

        # Returns the chat completions from the response.
        #
        # @return [Array] An array of chat completions.
        def chat_completions
          @response['choices']
        end

        # Returns the content from the first chat completion.
        #
        # @return [String, nil] The content or nil if not found.
        def content
          chat_completions&.dig(0, 'message', 'content')
        end

        # Parses the content as JSON and returns the parsed data.
        #
        # @return [Hash] The parsed JSON data.
        def parse
          JSON.parse(content)
        end
      end
    end
  end
end
