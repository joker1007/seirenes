require 'spec_helper'

describe DownloadList do
  describe ".download_all" do
    before do
      FactoryGirl.create_list(:download_list, 2)
    end

    it "should call NicoDownloader#rss_download" do
      NicoDownloader.any_instance.should_receive(:rss_download).with(an_instance_of(String), Settings.download_dir).twice
      described_class.download_all
    end
  end
end
