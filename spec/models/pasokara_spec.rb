require 'spec_helper'

describe Pasokara do
  let(:pasokara) { FactoryGirl.create(:pasokara) }
  describe "SimpleTaggable" do
    it "has_many tags" do
      expect {
        pasokara.tag_list = ["tag1", "tag2"]
      }.to change(Tag, :count).by(2)
    end

    describe "#tag_list" do
      before do
        pasokara.tags << Tag.new(name: "tag1")
      end

      subject { pasokara.tag_list }

      it { should eq ["tag1"]}
    end
  end
end
