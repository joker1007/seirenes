module Pasokara::CreateMethods
  extend ActiveSupport::Concern

  module ClassMethods
    def create_by_movie_info(movie_info)
      md5_hash = File.open(movie_info.path, "rb:ASCII-8BIT") {|f| Digest::MD5.hexdigest(f.read(300 * 1024))}
      pasokara = create(
        title: movie_info.title.presence || File.basename(movie_info.path, ".*"),
        fullpath: movie_info.path,
        md5_hash: md5_hash,
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

    def create_by_directory(directory_path, info_path: nil, movie_path: nil, thumbnail_path: nil)
      movie_info = NicoDownloader::Info.from_directory(directory_path, info_path: info_path, movie_path: movie_path, thumbnail_path: thumbnail_path)
      create_by_movie_info(movie_info)
    end

    def create_by_movie_file(movie_file)
      directory_path = File.dirname(movie_file)
      thumbnail_file = File.join(directory_path, File.basename(movie_file, ".*") + ".jpg")
      info_file = File.join(directory_path, File.basename(movie_file, ".*") + "_info.xml")
      movie_info = NicoDownloader::Info.new(path: movie_file, thumbnail_path: File.exists?(thumbnail_file) ? thumbnail_file : nil)
      if File.exists?(info_file)
        movie_info.parse(File.read(info_file))
      end
      create_by_movie_info(movie_info)
    end

    def create_by_directory_all(directory_path)
      dir = Dir.open(directory_path)
      dir.lazy.select {|f| f =~ /\.(mp4|mpg|wmv|flv|mkv|avi|ogm|m4v)$/i}.map {|f| File.join(directory_path, f)}.each do |f|
        create_by_movie_file(f)
      end
    end

    def create_by_directory_all_recursive(directory_path)
      queue = Queue.new

      dig_directory = ->(dir) do
        dir.lazy.reject{|e| e =~ /^\./}.map {|e| File.join(dir.path, e)}.each do |f|
          if File.directory?(f)
            dig_directory.(Dir.open(f))
          elsif f =~ /\.(mp4|mpg|wmv|flv|mkv|avi|ogm|m4v)$/i
            queue << f
          end
        end
      end

      dir = Dir.open(directory_path)

      th1 = Thread.new do
        dig_directory.(dir)
      end

      while th1.status || !queue.empty?
        create_by_movie_file(queue.pop)
      end

      th1.join
    end
  end
end
