# frozen_string_literal: true

require 'instructor/base/patch'
# The Instructor module provides functionality for interacting with OpenAI's chat API.
module Instructor
  module OpenAI
    # The `Patch` module provides methods for patching and modifying the OpenAI client behavior.
    module Patch
      include Instructor::Base::Patch

      # Sends a chat request to the API and processes the response.
      #
      # @param parameters [Hash] The parameters for the chat request as expected by the OpenAI client.
      # @param response_model [Class] The response model class.
      # @param validation_context [Hash] The validation context for the parameters. Optional.
      # @return [Object] The processed response.
      def chat(parameters:, response_model: nil, tool_choice: :auto, validation_context: nil)
        return super(parameters:) if response_model.nil?

        model = determine_model(response_model)
        if Instructor::OpenAI::Mode.structured_output?
          schema = build_schema(model)
          parameters = prepare_response_format(parameters, validation_context, schema)
        elsif Instructor::OpenAI::Mode.function_calling?
          function = build_function(model)
          parameters = prepare_parameters(parameters, validation_context, function)
          tool_choice = resolve_tool_choice(tool_choice, function_name(function))
          parameters.merge!(tool_choice:) if tool_choice
        else
          raise ArgumentError, 'Invalid mode'
        end
        response = super(parameters:)
        process_response(response, model)
      end

      def mode
        Instructor::OpenAI.mode
      end

      # Processes the API response.
      #
      # @param response [Hash] The API response.
      # @param model [Class] The response model class.
      # @return [Object] The processed response.
      def process_response(response, model)
        response_object = Response.create(response)
        raise ArgumentError, response_object.refusal if response_object.refusal.present?

        parsed_response = response_object.parse
        iterable? ? process_multiple_responses(parsed_response, model) : process_single_response(parsed_response, model)
      end

      private

      def function_name(function)
        function[:function][:name]
      end

      def resolve_tool_choice(tool_choice, function_name)
        string_choices = {
          auto: 'auto',
          required: 'required',
          none: 'none'
        }

        return string_choices[tool_choice] if string_choices.key?(tool_choice)

        # For :force or any other value, return the function hash
        { type: 'function', function: { name: function_name } }
      end

      # Builds the function details for the API request.
      #
      # @param model [Class] The response model class.
      # @return [Hash] The function details.
      def build_function(model)
        {
          type: 'function',
          function: {
            name: generate_function_name(model),
            description: generate_description(model),
            parameters: model.json_schema
          }
        }
      end

      def build_schema(model)
        {
          type: 'json_schema',
          json_schema: {
            name: generate_function_name(model),
            schema: model.json_schema,
            strict: true
          }
        }
      end

      def prepare_response_format(parameters, validation_context, schema)
        # parameters # fetch the parameters's max_token or set it to 1024
        parameters = apply_validation_context(parameters, validation_context)
        parameters.merge(response_format: schema)
      end
    end
  end
end
