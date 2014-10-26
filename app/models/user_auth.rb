# == Schema Information
#
# Table name: user_auths
#
#  id         :integer          not null, primary key
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_user_auths_on_provider_and_uid  (provider,uid) UNIQUE
#  index_user_auths_on_user_id           (user_id)
#

class UserAuth < ActiveRecord::Base
  belongs_to :user, required: true

  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid, scope: [:provider]
end
