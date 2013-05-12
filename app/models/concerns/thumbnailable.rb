module Thumbnailable
  extend ActiveSupport::Concern

  THUMBNAIL_SIZE = "160x120".freeze

  def create_thumbnail(force = false)
    if force || thumbnail.blank?
      ffmpegthumbnailer = `which ffmpegthumbnailer`.chomp
      if ffmpegthumbnailer.present?
        if system("#{ffmpegthumbnailer} -t 10% -s #{THUMBNAIL_SIZE} -i #{fullpath} -o #{temp_thumbnail_path}")
          update(thumbnail: File.open(temp_thumbnail_path))
          FileUtils.rm(temp_thumbnail_path, force: true)
        else
          Rails.logger.tagged("create_thumbnail") do |logger|
            logger.warn("Create Thumbnail Error #{fullpath}")
          end
        end
      end
    end
  end

  private
  def temp_thumbnail_path
    @temp_thumbnail_path ||= (Rails.root + "tmp/#{SecureRandom.hex(10)}.jpg").to_s
  end
end
