require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  handler do |job|
    DownloadList.download_all
  end

  every(1.day, 'daily.download', at: '06:00')
end
