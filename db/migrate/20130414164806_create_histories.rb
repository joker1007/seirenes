class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :pasokara, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
