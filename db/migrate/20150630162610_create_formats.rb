class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
      t.string :name
      t.references :media, index: true

      t.timestamps
    end
  end
end
