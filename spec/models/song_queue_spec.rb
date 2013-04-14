require 'spec_helper'

describe SongQueue do
  describe "#finish!" do
    let(:pasokara) { FactoryGirl.create(:pasokara) }
    let!(:song_queue) { FactoryGirl.create(:song_queue, pasokara: pasokara) }

    subject { song_queue.finish! }

    it "remove SongQueue and create History" do
      song_queue.should_receive(:destroy!)
      subject
    end

    it "create History" do
      expect{ subject }.to change(History, :count).to(1)
    end

    describe "created History" do
      it "is related with song_queue.pasokara" do
        subject
        History.last.pasokara.should eq pasokara
      end
    end
  end
end
