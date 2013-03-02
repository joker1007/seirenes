class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :screen_name, null: false

      t.timestamps
    end
  end
end
