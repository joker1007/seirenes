class CreateRecordedSongs < ActiveRecord::Migration
  def change
    create_table :recorded_songs do |t|
      t.string :data
      t.boolean :public_flag
      t.references :user, index: true
      t.references :pasokara, index: true

      t.timestamps
    end
  end
end
