class CreatePasokaras < ActiveRecord::Migration
  def change
    create_table :pasokaras do |t|
      t.string :title, null: false
      t.string :fullpath, null: false
      t.string :md5_hash, null: false
      t.string :nico_vid
      t.datetime :nico_posted_at
      t.integer :nico_view_count, null: false, default: 0
      t.integer :nico_mylist_count, null: false, default: 0
      t.integer :duration
      t.string :nico_description, size: 700

      t.timestamps
    end

    add_index :pasokaras, :md5_hash, unique: true
    add_index :pasokaras, :nico_vid, unique: true
  end
end
