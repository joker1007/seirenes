class EncodeJob
  extend Resque::Ffmpeg::BaseJob

  @queue = :seirenes

  def self.on_complete(encoder, extra_data = {})
    pasokara = Pasokara.find(extra_data["id"])

    case encoder
    when Resque::Ffmpeg::Encoder::MP4
      pasokara.movie_mp4 = File.open(encoder.output_filename)
    when Resque::Ffmpeg::Encoder::WebM
      pasokara.movie_webm = File.open(encoder.output_filename)
    end

    pasokara.save
  end
end
