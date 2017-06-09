class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :english_name
      t.text :description
      t.attachment :photo

      t.timestamps
    end
  end
end
