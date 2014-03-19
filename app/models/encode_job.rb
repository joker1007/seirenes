class EncodeJob < Sidekiq::Ffmpeg::BaseJob
  sidekiq_options queue: :seirenes

  def on_progress(progress, extra_data = {})
    @redis ||= Redis.new
    r = Redis::Namespace.new(:seirenes_pasokara_encoding, redis: @redis)
    r[extra_data["id"].to_s] = (progress * 100).to_i
  end

  def on_complete(encoder, extra_data = {})
    pasokara = Pasokara.find(extra_data["id"])

    @redis ||= Redis.new
    r = Redis::Namespace.new(:seirenes_pasokara_encoding, redis: @redis)
    r.del(extra_data["id"].to_s)

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
