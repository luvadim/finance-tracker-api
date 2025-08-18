module OpenAi
  class Transcribe < BaseService
    def initialize(file)
      @file = file
    end

    def call
      key = Rails.application.credentials.openai_api_key
      client = OpenAI::Client.new(access_token: key)

      if client
        File.open(@file) do |audio_file|
        response = client.audio.transcribe(
          parameters: {
            model: "whisper-1",
            file: audio_file
          }
        )

        response['text']
        end
      end
    end
  end
end