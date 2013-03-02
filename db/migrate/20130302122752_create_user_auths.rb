class CreateUserAuths < ActiveRecord::Migration
  def change
    create_table :user_auths do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.references :user

      t.timestamps
    end

    add_index :user_auths, :user_id
  end
end
