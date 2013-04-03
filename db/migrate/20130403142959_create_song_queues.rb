class CreateSongQueues < ActiveRecord::Migration
  def change
    create_table :song_queues do |t|
      t.references :pasokara, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
