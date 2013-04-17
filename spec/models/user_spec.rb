require 'spec_helper'

describe User do
  let(:auth) do
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      :provider => 'twitter',
      :uid => '123545',
      :info => {
        :nickname => "joker1007",
        :name => "Tomohiro Hashidate",
      },
      :credentials => {
        :token => "token",
        :secret => "secret"
      }
    })
  end

  describe ".find_or_create_by_omniauth" do
    subject { User.find_or_create_by_omniauth(auth) }

    it "creates user" do
      expect{subject}.to change(User, :count).by(1)
    end

    it "creates user_auth" do
      UserAuth.count.should == 0
      subject
      user_auth = UserAuth.find_by(provider: "twitter")
      user_auth.should be_present
      user_auth.uid.should == "123545"
      user_auth.user.should be_present
    end

    context "When User is already exists" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        user.user_auths.create!(provider: "twitter", uid: "123545")
      end

      it "returns existing user" do
        subject.should == user
      end
    end
  end
end
