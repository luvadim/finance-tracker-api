require 'down'
require 'streamio-ffmpeg'

module Transactions
  class AudioProcessor < BaseService
    def initialize(voice_url)
      @voice_url = voice_url
    end

    def call
      tempfile = Down.download(@voice_url)
      input_file = FFMPEG::Movie.new(tempfile.path)
      output_file = 'output.wav'
      input_file.transcode(output_file)

      if output_file
        # Use OpenAI's Whisper API to transcribe the audio file
        OpenAi::Transcribe.call(output_file)
      end
    end
  end
end