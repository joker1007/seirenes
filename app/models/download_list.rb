class DownloadList < ActiveRecord::Base
  class << self
    def download_all
      downloader = NicoDownloader.new
      downloader.on_download_complete = ->(movie_info) do
        md5_hash = File.open(movie_info.path, "rb:ASCII-8BIT") {|f| Digest::MD5.hexdigest(f.read(300 * 1024))}
        Pasokara.create(
          title: movie_info.title,
          fullpath: movie_info.path,
          md5_hash: md5_hash,
          duration: movie_info.duration,
          nico_vid: movie_info.vid,
          nico_view_count: movie_info.view_count,
          nico_mylist_count: movie_info.mylist_count,
          nico_posted_at: movie_info.posted_at,
          nico_description: movie_info.description
        )
      end

      all.each do |list|
        downloader.rss_download(list.url, Settings.download_dir)
      end
    end
  end
end
