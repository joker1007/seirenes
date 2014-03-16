shared_context "indexed_pasokara" do
  let!(:pasokara) { create(:pasokara) }

  before do
    pasokara.__elasticsearch__.index_document
    Elasticsearch::Model.client.indices.flush
  end
end
