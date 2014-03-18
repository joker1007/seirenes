class RecordedSongEncodeJob
  include Sidekiq::Worker
  sidekiq_options queue: :seirenes

  def perform(input_filename, user_id, pasokara_id)
    ffmpeg = `which ffmpeg`.chomp
    temp_filename = (Rails.root + "tmp" + "#{SecureRandom.hex}.m4a").to_s
    cmd = "#{ffmpeg} -i #{Shellwords.shellescape(input_filename)} -acodec libfaac -f mp4 -af volume=volume=3dB:precision=fixed #{Shellwords.shellescape(temp_filename)}"
    Rails.logger.tagged("RecordedSongEncodeJob") {|logger| logger.info("cmd: #{cmd}")}
    unless system(cmd)
      Rails.logger.tagged("RecordedSongEncodeJob") {|logger| logger.error("Encode failed")}
    end

    user = User.find(user_id)
    recorded_song = user.recorded_songs.new
    recorded_song.data = File.open(temp_filename, "rb")
    recorded_song.pasokara_id = pasokara_id
    recorded_song.save
  ensure
    FileUtils.rm(input_filename) if File.exists?(input_filename)
    FileUtils.rm(temp_filename) if File.exists?(temp_filename)
  end
end
