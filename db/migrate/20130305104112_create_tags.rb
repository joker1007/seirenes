class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE tags CHANGE COLUMN name name varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL;
    SQL

    add_index :tags, :name
  end
end
