require 'down'
require 'streamio-ffmpeg'

module Transactions
  class AudioProcessor < BaseService
    def initialize(voice_url, transcribe_service = OpenAi::Transcribe)
      @voice_url = voice_url
      @transcribe_service = transcribe_service
    end

    def call
      tempfile = Down.download(@voice_url)
      input_file = FFMPEG::Movie.new(tempfile.path)
      output_file = 'output.wav'
      input_file.transcode(output_file)

      if output_file
        # Use OpenAI's Whisper API to transcribe the audio file
        @transcribe_service.call(output_file)
      end
    end
  end
end