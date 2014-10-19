require 'spec_helper'

describe DownloadList, type: :model do
  describe ".download_all" do
    before do
      FactoryGirl.create_list(:download_list, 2)
    end

    it "should call NicoDownloader#rss_download" do
      expect_any_instance_of(NicoDownloader).to receive(:rss_download).with(an_instance_of(String), Settings.download_dir).twice
      described_class.download_all
    end
  end
end
