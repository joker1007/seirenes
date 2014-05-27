require 'spec_helper'

describe EncodingsController, :type => :controller do
  let(:pasokara) { FactoryGirl.create(:pasokara) }

  describe "POST create" do
    it "Add Pasokara encode queue" do
      expect(Pasokara).to receive(:find).with(pasokara.id.to_s).and_return(pasokara)
      expect(pasokara).to receive(:encode_async)
      post :create, pasokara_id: pasokara.id
    end
  end
end
