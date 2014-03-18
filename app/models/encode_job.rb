class EncodeJob < Sidekiq::Ffmpeg::BaseJob
  def on_complete(encoder, extra_data = {})
    pasokara = Pasokara.find(extra_data["id"])

    begin
      case encoder
      when Sidekiq::Ffmpeg::Encoder::MP4
        pasokara.movie_mp4 = File.open(encoder.output_filename)
      when Sidekiq::Ffmpeg::Encoder::WebM
        pasokara.movie_webm = File.open(encoder.output_filename)
      end

      pasokara.save

      File.delete(encoder.output_filename)
    ensure
      Rails.cache.delete("pasokara_#{pasokara.id}_encoding")
    end
  end
end
