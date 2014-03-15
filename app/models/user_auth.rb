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

class UserAuth < ActiveRecord::Base
  belongs_to :user
end
