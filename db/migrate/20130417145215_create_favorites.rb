class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, null: false, index: true
      t.references :pasokara, null:false, index: true

      t.timestamps
    end
  end
end
