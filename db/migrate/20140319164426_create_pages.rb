class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.text :content
      t.string :position
      t.integer :order
      t.boolean :visible

      t.timestamps
    end
  end
end
