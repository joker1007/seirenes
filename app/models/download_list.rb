# == Schema Information
#
# Table name: download_lists
#
#  id         :integer          not null, primary key
#  url        :string(255)      not null
#  download   :boolean          default(TRUE), not null
#  created_at :datetime
#  updated_at :datetime
#

class DownloadList < ActiveRecord::Base
  class << self
    def download_all
      downloader = NicoDownloader.new
      downloader.on_download_complete = ->(movie_info) do
        Pasokara.create_by_movie_info(movie_info)
      end

      all.each do |list|
        downloader.rss_download(list.url, Settings.download_dir)
      end
    end
  end
end
