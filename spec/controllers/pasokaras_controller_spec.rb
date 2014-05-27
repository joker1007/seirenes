require 'spec_helper'

describe PasokarasController, :type => :controller do

  describe "GET 'index'" do
    it "returns http success" do
      resp = double(:response)
      search_parameter = Pasokara::Searchable::SearchParameter.new
      expect(Pasokara).to receive(:search_with_facet_tags).with(search_parameter) {
        resp
      }
      allow(resp).to receive_message_chain(:records, :includes) { [mock_model(Pasokara)] }
      expect(resp).to receive(:response) {
        {"facets" => {
          "tags" => {
            "terms" => []
          }
        }}
      }
      get 'index'
      expect(response).to be_success
    end
  end
end
