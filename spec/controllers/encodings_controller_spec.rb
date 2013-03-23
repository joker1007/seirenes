require 'spec_helper'

describe EncodingsController do
  let(:pasokara) { FactoryGirl.create(:pasokara) }

  describe "POST create" do
    it "Add Pasokara encode queue" do
      Pasokara.should_receive(:find).with(pasokara.id.to_s).and_return(pasokara)
      pasokara.should_receive(:encode_async)
      post :create, pasokara_id: 1
    end
  end
end
