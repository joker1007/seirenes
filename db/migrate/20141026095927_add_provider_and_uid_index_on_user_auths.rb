class AddProviderAndUidIndexOnUserAuths < ActiveRecord::Migration
  def change
    add_index :user_auths, [:provider, :uid], unique: true
  end
end
