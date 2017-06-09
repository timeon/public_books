class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.references :user, index: true
      t.string :phone
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.attachment :photo
      t.boolean :verified
      t.boolean :disabled
      t.boolean :one_more_year
      t.string :key
      t.string :note

      t.timestamps
    end
  end
end
