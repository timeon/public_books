class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.references :family, index: true
      t.string :relation
      t.string :first_name
      t.string :last_name
      t.string :chinese_name
      t.string :email
      t.string :phone
      t.integer :phone_ext

      t.timestamps
    end
  end
end
