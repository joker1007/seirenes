class CreateDownloadLists < ActiveRecord::Migration
  def change
    create_table :download_lists do |t|
      t.string :url, null: false
      t.boolean :download, null: false, default: true

      t.timestamps
    end
  end
end
