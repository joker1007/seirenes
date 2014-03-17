require 'spec_helper'

describe Pasokara do
  let(:pasokara) { create(:pasokara) }

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
      let(:pasokara2) { FactoryGirl.create(:pasokara, fullpath: "other path") }

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
    its(:tags) { should eq %w(vocaloid tag2).map {|n| Tag.new(name: n)} }
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
    its(:tags) { should eq %w(vocaloid tag2).map {|n| Tag.new(name: n)} }
  end

  describe "#favorited_by?" do
    let(:pasokara) { FactoryGirl.create(:pasokara) }
    let(:user) { FactoryGirl.create(:user) }

    subject { pasokara.favorited_by?(user) }

    context "user has pasokara" do
      before do
        user.pasokaras << pasokara
      end

      it { should be_true }
    end

    context "user has no pasokara" do
      it { should be_false }
    end
  end

  describe "#encode_async" do
    before do
      Rails.cache.clear
    end

    subject { pasokara.encode_async }

    it "call Resque.enqueue" do
      expect(Resque).to receive(:enqueue).with(EncodeJob, pasokara.fullpath, an_instance_of(String), {"id" => pasokara.id}, :mp4)
      subject
    end

    it "prevent double enqueue" do
      expect(Resque).to receive(:enqueue).with(EncodeJob, pasokara.fullpath, an_instance_of(String), {"id" => pasokara.id}, :mp4).once
      subject
      pasokara.encode_async
    end
  end

  describe "ElasticSearch", elasticsearch: true do
    let(:pasokara) { create(:pasokara, title: "日本語混じりのTitle") }
    let(:pasokara2) { create(:pasokara, :with_other_file, title: "Other Title") }

    before do
      pasokara.tag_list = %w(tag1 tag2)
      pasokara.save
    end

    it "indexing" do
      pasokara.__elasticsearch__.index_document
      Elasticsearch::Model.client.indices.flush
      response = Pasokara.search(query: {match: {tags: "tag1"}})
      expect(response.results).to have(1).items
      expect(response.records.first).to eq pasokara
    end

    it "searchable in Japanese" do
      pasokara.__elasticsearch__.index_document
      pasokara2.__elasticsearch__.index_document
      Elasticsearch::Model.client.indices.flush
      response = Pasokara.search(query: {match: {title: "混じり"}})
      expect(response.records).to have(1).items
      expect(response.records.first).to eq pasokara
    end

    it "searchable in English" do
      pasokara.__elasticsearch__.index_document
      pasokara2.__elasticsearch__.index_document
      Elasticsearch::Model.client.indices.flush
      response = Pasokara.search(query: {match: {title: "Title"}})
      expect(response.records).to have(2).items
      expect(response.records.sort_by(&:id).first).to eq pasokara
    end

    describe ".search_with_facet_tags" do
      let(:pasokara)  { create(:pasokara, title: "日本語混じりのTitle") }
      let(:pasokara2) { create(:pasokara, :with_other_file, title: "Other Title") }
      let(:pasokara3) { create(:pasokara, :seq, title: "その他の楽曲") }
      let(:user) { create(:user) }

      before do
        pasokara.tag_list = %w(tag1 tag2)
        pasokara.save

        pasokara2.tag_list = %w(tag2 tag3)
        pasokara2.save

        pasokara3.tag_list = %w(タグ)
        pasokara3.save

        pasokara3.users << user

        pasokara.__elasticsearch__.index_document
        pasokara2.__elasticsearch__.index_document
        pasokara3.__elasticsearch__.index_document
        Elasticsearch::Model.client.indices.flush
      end

      it "検索結果と共にfacetが取得できること" do
        parameter = Pasokara::SearchParameter.new(keyword: "Title")
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results).to have(2).items
        expect(response.records[0]).to eq pasokara2
        expect(response.records[1]).to eq pasokara
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"]).to have(3).items
        expect(response.response["facets"]["tags"]["terms"][0]["term"]).to eq "tag2"
        expect(response.response["facets"]["tags"]["terms"][0]["count"]).to eq 2
      end

      it "SearchParameterにタグを渡して絞り込めること" do
        parameter = Pasokara::SearchParameter.new(keyword: "Title", tags: %w(tag1))
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results).to have(1).items
        expect(response.records[0]).to eq pasokara
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"]).to have(2).items
      end

      it "keywordの指定が無い場合は全件を返す" do
        parameter = Pasokara::SearchParameter.new
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results).to have(3).items
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"]).to have(4).items
      end

      it "日本語のタグで検索する" do
        parameter = Pasokara::SearchParameter.new(tags: %w(タグ))
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results).to have(1).items
        expect(response.records[0]).to eq pasokara3
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"]).to have(1).items
      end

      it "複数のタグにマッチする結果を返す" do
        parameter = Pasokara::SearchParameter.new(tags: %w(tag2 Tag3))
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results).to have(1).items
        expect(response.records[0]).to eq pasokara2
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"]).to have(2).items
      end

      it "ページネーションされている" do
        create_list(:pasokara, 10, :seq).each do |paso|
          paso.__elasticsearch__.index_document
        end
        Elasticsearch::Model.client.indices.flush

        parameter = Pasokara::SearchParameter.new(per_page: 10)
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.records).to have(10).items
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"]).to have(4).items

        parameter = Pasokara::SearchParameter.new(page: 2, per_page: 10)
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.records).to have(3).items
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"]).to have(4).items
      end

      it "user_idで検索できる" do
        parameter = Pasokara::SearchParameter.new(user_id: user.id)
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.records).to have(1).items
        expect(response.records[0]).to eq pasokara3
      end

      it "ソート方法を指定できる" do
        parameter = Pasokara::SearchParameter.new(order_by: [[:created_at, :asc]])
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.records).to have(3).items
        expect(response.records[0]).to eq pasokara
      end
    end
  end
end
