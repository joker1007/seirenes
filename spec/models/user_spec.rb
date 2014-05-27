require 'spec_helper'

describe User, :type => :model do
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
      expect(UserAuth.count).to eq(0)
      subject
      user_auth = UserAuth.find_by(provider: "twitter")
      expect(user_auth).to be_present
      expect(user_auth.uid).to eq("123545")
      expect(user_auth.user).to be_present
    end

    context "When User is already exists" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        user.user_auths.create!(provider: "twitter", uid: "123545")
      end

      it "returns existing user" do
        expect(subject).to eq(user)
      end
    end
  end
end
