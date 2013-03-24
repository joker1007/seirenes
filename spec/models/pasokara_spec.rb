require 'spec_helper'

describe Pasokara do
  let(:pasokara) { FactoryGirl.create(:pasokara) }

  describe "SimpleTaggable" do
    describe "#tag_list=" do
      it "should accept tags Array" do
        pasokara.tag_list.should eq []
        pasokara.tag_list = ["tag1", "tag2"]
        pasokara.tag_list.should eq ["tag1", "tag2"]
        pasokara.tag_list.should be_instance_of(TagList)
      end

      it "should accept tags Strings" do
        pasokara.tag_list.should eq []
        pasokara.tag_list = "tag1", "tag2"
        pasokara.tag_list.should eq %w(tag1 tag2)
        pasokara.tag_list.should be_instance_of(TagList)
      end
    end

    describe "#add_tag" do
      before do
        pasokara.tag_list = ["tag1", "tag2"]
        pasokara.tag_list.should eq ["tag1", "tag2"]
      end

      it "should add tag to tag_list" do
        pasokara.add_tag("tag3", "tag4")
        pasokara.tag_list.should eq %w(tag1 tag2 tag3 tag4)
      end

      it "should keep tag_list unique" do
        pasokara.add_tag("tag1")
        pasokara.tag_list.should eq %w(tag1 tag2)
      end
    end

    context "After saving" do
      it "should save own tags" do
        pasokara.tag_list = %w(tag1 tag2)
        pasokara.save
        pasokara.tags.pluck(:name).should eq %w(tag1 tag2)
      end

      it "should add existing tag" do
        Tag.create(name: "tag1")
        pasokara.tag_list = %w(tag1 tag2)
        pasokara.save
        pasokara.tags.pluck(:name).should eq %w(tag1 tag2)
      end

      it "should destroy relation with no used tags" do
        pasokara.tag_list = %w(tag1 tag2)
        pasokara.save
        pasokara.tags.pluck(:name).should eq %w(tag1 tag2)
        pasokara.tag_list.delete("tag2")
        pasokara.save
        pasokara.tags.pluck(:name).should eq %w(tag1)
      end
    end

    describe ".tagged_with(tags)" do
      let(:pasokara2) { FactoryGirl.create(:pasokara) }

      before do
        pasokara.tag_list = %w(tag1 tag2)
        pasokara.save
        pasokara2.tag_list = %w(tag2)
        pasokara2.save
      end


      context "given tag1" do
        subject { Pasokara.tagged_with("tag1") }

        it { should eq [pasokara] }
      end

      context "given tag2" do
        subject { Pasokara.tagged_with("tag2") }

        it { should eq [pasokara, pasokara2] }
      end

      context "given tag1 and tag2" do
        subject { Pasokara.tagged_with("tag1", "tag2") }

        it { should eq [pasokara, pasokara2] }
      end
    end
  end

  describe ".create_by_movie_info" do
    let(:info_file) { Rails.root + "spec/datas/testdir1/test002_info.xml" }
    let(:movie_file) { Rails.root + "spec/datas/testdir1/test002.mp4" }
    let(:movie_info) do
      info = NicoDownloader::Info.parse(File.read(info_file))
      info.path = movie_file.to_s
      info
    end

    before do
      movie_info.title.should_not be_blank
    end

    subject { Pasokara.create_by_movie_info(movie_info) }

    it "creates Pasokara" do
      expect { subject }.to change(Pasokara, :count).by(1)
    end

    its(:title) { should eq movie_info.title }
    its(:duration) { should eq 205 }
    its(:nico_posted_at) { should eq Time.zone.local(2011, 7, 21, 3, 29, 1) }
    its(:tags) { should eq %w(VOCALOID tag2).map {|n| Tag.new(name: n)} }
  end

  describe ".create_by_movie_file" do
    let(:movie_file) { (Rails.root + "spec/datas/testdir1/test002.mp4").to_s }

    subject { Pasokara.create_by_movie_file(movie_file) }

    it "creates Pasokara" do
      expect { subject }.to change(Pasokara, :count).by(1)
    end

    its(:fullpath) { should eq (Rails.root + "spec/datas/testdir1/test002.mp4").to_s }
    its(:duration) { should eq 205 }
    its(:nico_posted_at) { should eq Time.zone.local(2011, 7, 21, 3, 29, 1) }
    its(:tags) { should eq %w(VOCALOID tag2).map {|n| Tag.new(name: n)} }
  end
end
