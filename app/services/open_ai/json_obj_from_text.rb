module OpenAi
  class JsonObjFromText < BaseService
    def initialize(text, system_prompot)
      @text = text
      @system_prompot = system_prompot
    end

    def call
      key = Rails.application.credentials.openai_api_key
      client = OpenAI::Client.new(access_token: key)

      if client
        chat_response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            response_format: { type: "json_object" },
            messages: [
              { role: "system", content: @system_prompot },
              { role: "user", content: @text }
            ]
          }
        )

        chat_response
      end
    end
  end
end