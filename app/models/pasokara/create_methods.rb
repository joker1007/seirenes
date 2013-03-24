module Pasokara::CreateMethods
  extend ActiveSupport::Concern

  module ClassMethods
    def create_by_movie_info(movie_info)
      pasokara = create(
        title: movie_info.title.presence || File.basename(movie_info.path, ".*"),
        fullpath: movie_info.path,
        duration: movie_info.duration,
        nico_vid: movie_info.vid.presence,
        nico_view_count: movie_info.view_count,
        nico_mylist_count: movie_info.mylist_count,
        nico_posted_at: movie_info.posted_at,
        nico_description: movie_info.description
      )
      pasokara.tag_list = movie_info.tags
      pasokara.thumbnail = File.open(movie_info.thumbnail_path) if movie_info.thumbnail_path.present? && File.exists?(movie_info.thumbnail_path)
      pasokara.save
      pasokara
    end

    def create_by_movie_file(movie_file)
      directory_path = File.dirname(movie_file)
      thumbnail_file = File.join(directory_path, File.basename(movie_file, ".*") + ".jpg")
      info_file = File.join(directory_path, File.basename(movie_file, ".*") + "_info.xml")
      movie_info = NicoDownloader::Info.new(path: movie_file, posted_at: nil, thumbnail_path: File.exists?(thumbnail_file) ? thumbnail_file : nil)
      if File.exists?(info_file)
        movie_info.parse(File.read(info_file))
      end
      create_by_movie_info(movie_info)
    rescue NicoDownloader::Info::InvalidInfoFile
      nil
    end
  end
end
