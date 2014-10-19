require 'spec_helper'

describe Pasokara, type: :model, elasticsearch: true do
  let(:pasokara) { create(:pasokara) }

  describe ".create_by_movie_info" do
    let(:info_file) { Rails.root + "spec/datas/testdir1/test002_info.xml" }
    let(:movie_file) { Rails.root + "spec/datas/testdir1/test002.mp4" }
    let(:movie_info) do
      info = NicoDownloader::Info.parse(File.read(info_file))
      info.path = movie_file.to_s
      info
    end

    before do
      expect(movie_info.title).not_to be_blank
    end

    subject { Pasokara.create_by_movie_info(movie_info) }

    it "creates Pasokara" do
      expect { subject }.to change(Pasokara, :count).by(1)
    end

    its(:title) { is_expected.to eq movie_info.title }
    its(:duration) { is_expected.to eq 205 }
    its(:nico_posted_at) { is_expected.to eq Time.zone.local(2011, 7, 21, 3, 29, 1) }
    its(:tags) {
      is_expected.to match_array SimpleTaggable::Models::Tag.where(name: %w(vocaloid tag2))
    }
  end

  describe ".create_by_movie_file" do
    let(:movie_file) { (Rails.root + "spec/datas/testdir1/test002.mp4").to_s }

    subject { Pasokara.create_by_movie_file(movie_file) }

    it "creates Pasokara" do
      expect { subject }.to change(Pasokara, :count).by(1)
    end

    its(:fullpath) { is_expected.to eq (Rails.root + "spec/datas/testdir1/test002.mp4").to_s }
    its(:duration) { is_expected.to eq 205 }
    its(:nico_posted_at) { is_expected.to eq Time.zone.local(2011, 7, 21, 3, 29, 1) }
    its(:tags) {
      is_expected.to match_array SimpleTaggable::Models::Tag.where(name: %w(vocaloid tag2))
    }
  end

  describe "#favorited_by?" do
    let(:pasokara) { FactoryGirl.create(:pasokara) }
    let(:user) { FactoryGirl.create(:user) }

    subject { pasokara.favorited_by?(user) }

    context "user has pasokara" do
      before do
        user.pasokaras << pasokara
      end

      it { is_expected.to be_truthy }
    end

    context "user has no pasokara" do
      it { is_expected.to be_falsey }
    end
  end

  describe "#encode_async" do
    subject { pasokara.encode_async }

    it "call EncodeJob.perform_async" do
      expect(EncodeJob).to receive(:perform_async).with(pasokara.fullpath, an_instance_of(String), {"id" => pasokara.id}, :mp4)
      subject
    end
  end

  describe "ElasticSearch" do
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
      expect(response.results.size).to eq 1
      expect(response.records.first).to eq pasokara
    end

    it "searchable in Japanese" do
      pasokara.__elasticsearch__.index_document
      pasokara2.__elasticsearch__.index_document
      Elasticsearch::Model.client.indices.flush
      response = Pasokara.search(query: {match: {title: "混じり"}})
      expect(response.records.size).to eq 1
      expect(response.records.first).to eq pasokara
    end

    it "searchable in English" do
      pasokara.__elasticsearch__.index_document
      pasokara2.__elasticsearch__.index_document
      Elasticsearch::Model.client.indices.flush
      response = Pasokara.search(query: {match: {title: "Title"}})
      expect(response.records.size).to eq 2
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
        expect(response.results.size).to eq 2
        expect(response.records[0]).to eq pasokara2
        expect(response.records[1]).to eq pasokara
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"].size).to eq 3
        expect(response.response["facets"]["tags"]["terms"][0]["term"]).to eq "tag2"
        expect(response.response["facets"]["tags"]["terms"][0]["count"]).to eq 2
      end

      it "SearchParameterにタグを渡して絞り込めること" do
        parameter = Pasokara::SearchParameter.new(keyword: "Title", tags: %w(tag1))
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results.size).to eq 1
        expect(response.records[0]).to eq pasokara
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"].size).to eq 2
      end

      it "keywordの指定が無い場合は全件を返す" do
        parameter = Pasokara::SearchParameter.new
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results.size).to eq 3
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"].size).to eq 4
      end

      it "日本語のタグで検索する" do
        parameter = Pasokara::SearchParameter.new(tags: %w(タグ))
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results.size).to eq 1
        expect(response.records[0]).to eq pasokara3
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"].size).to eq 1
      end

      it "複数のタグにマッチする結果を返す" do
        parameter = Pasokara::SearchParameter.new(tags: %w(tag2 Tag3))
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.results.size).to eq 1
        expect(response.records[0]).to eq pasokara2
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"].size).to eq 2
      end

      it "ページネーションされている" do
        create_list(:pasokara, 10, :seq).each do |paso|
          paso.__elasticsearch__.index_document
        end
        Elasticsearch::Model.client.indices.flush

        parameter = Pasokara::SearchParameter.new(per_page: 10)
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.records.size).to eq 10
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"].size).to eq 4

        parameter = Pasokara::SearchParameter.new(page: 2, per_page: 10)
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.records.size).to eq 3
        expect(response.response["facets"]).to be_a(Hash)
        expect(response.response["facets"]["tags"]["terms"].size).to eq 4
      end

      it "user_idで検索できる" do
        parameter = Pasokara::SearchParameter.new(user_id: user.id)
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.records.size).to eq 1
        expect(response.records[0]).to eq pasokara3
      end

      it "ソート方法を指定できる" do
        parameter = Pasokara::SearchParameter.new(order_by: [[:created_at, :asc]])
        response = Pasokara.search_with_facet_tags(parameter)
        expect(response.records.size).to eq 3
        expect(response.records[0]).to eq pasokara
      end
    end

    describe ".random_search" do
      subject { Pasokara.random_search(parameter) }

      let(:parameter) { Pasokara::SearchParameter.new(keyword: "Title") }

      before do
        pasokara.__elasticsearch__.index_document
        pasokara2.__elasticsearch__.index_document
        Elasticsearch::Model.client.indices.flush
      end

      it_is_asserted_by { subject.records.to_a.length == 2 }
    end
  end
end
