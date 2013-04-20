class User < ActiveRecord::Base
  has_many :user_auths
  has_many :favorites
  has_many :pasokaras, through: :favorites

  class << self
    def find_or_create_by_omniauth(auth)
      case auth.provider
      when "twitter"
        user = User.joins(:user_auths).merge( UserAuth.where(provider: auth.provider, uid: auth.uid) ).first
        return user if user

        transaction do
          user = create!(screen_name: auth.info.nickname)
          user.user_auths.create!(provider: auth.provider, uid: auth.uid)
        end
      else
      end

      user
    end
  end
end
