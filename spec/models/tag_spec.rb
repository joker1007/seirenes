require 'spec_helper'

describe Tag do
  describe "#==" do
    let(:tag1) { Tag.new(name: "tag") }
    let(:tag2) { Tag.new(name: "tag") }

    subject { tag1 == tag2 }

    it { should be_true }
  end

  describe "#to_s" do
    let(:tag) { Tag.new(name: "tag") }

    subject { tag.to_s }

    it { should eq "tag" }
  end
end
