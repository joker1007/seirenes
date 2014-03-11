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

  describe "ElasticSearch", elasticsearch: true do
    let!(:tag) { create(:tag, name: "タグ") }
    let!(:tag2) { create(:tag, name: "tag") }

    it "indexing" do
      tag.__elasticsearch__.index_document
      tag2.__elasticsearch__.index_document
      Elasticsearch::Model.client.indices.flush
      response = Tag.search(query: {match: {name: "タグ"}})
      expect(response.results).to have(1).items
      expect(response.records.first).to eq tag
    end
  end
end
