class Pasokara::DirectoryCrawler
  class << self
    def crawl(directory)
      worker_pool = Worker.pool
      future = worker_pool.future.crawl(directory)
      p future.value
    end
  end

  class Worker
    include Celluloid

    def process(filepath)
      puts "Process File: #{filepath}"
      if filepath.size > 255
        File.open(Rails.root + "log/too_long_filename.log", "a") do |file|
          file.puts filepath
        end
      end
      Pasokara.create_by_movie_file(filepath)
    end

    def crawl(directory)
      dir = Dir.open(directory)
      futures = []
      dir.reject { |name| name =~ /^\./ }.each do |name|
        path = File.join(directory, name)
        if File.directory?(path)
          puts "Open Dir: #{path}"
          futures << future.crawl(path)
        elsif path =~ /\.(mp4|mpg|wmv|flv|mkv|avi|ogm|m4v)$/i
          process(path)
        end
      end
      dir.close
      futures.map(&:value)
    end
  end
end
