class AddIndexToPasokarasTitle < ActiveRecord::Migration
  def change
    add_index :pasokaras, :title
  end
end
