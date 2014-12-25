class EncodeJob < Sidekiq::Ffmpeg::BaseJob
  sidekiq_options queue: :seirenes

  def perform(input_filename, output_filename, extra_data = {}, format = :mp4)
    RedisMutex.with_lock("seirenes_pasokara_#{extra_data["id"]}_encoding", block: 0, expire: 60.minutes) do
      super
    end
  rescue RedisMutex::LockError
    puts "Already encoding"
  end

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

    case encoder
    when Sidekiq::Ffmpeg::Encoder::MP4
      pasokara.movie_mp4 = File.open(encoder.output_filename)
    when Sidekiq::Ffmpeg::Encoder::WebM
      pasokara.movie_webm = File.open(encoder.output_filename)
    end

    pasokara.save

    File.delete(encoder.output_filename)
  end
end
