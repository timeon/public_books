class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :home_phone
      t.string :street_no_and_name
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :adult_1_first_name
      t.string :adult_1_last_name
      t.string :adult_1_chinese_name
      t.string :adult_1_email
      t.string :adult_1_phone
      t.integer :adult_1_phone_ext
      t.string :adult_2_first_name
      t.string :adult_2_last_name
      t.string :adult_2_chinese_name
      t.string :adult_2_email
      t.string :adult_2_phone
      t.integer :adult_2_phone_ext
      t.string :child_1_relation
      t.string :child_1_first_name
      t.string :child_1_last_name
      t.string :child_1_chinese_name
      t.string :child_2_relation
      t.string :child_2_first_name
      t.string :child_2_last_name
      t.string :child_2_chinese_name
      t.string :child_3_relation
      t.string :child_3_first_name
      t.string :child_3_last_name
      t.string :child_3_chinese_name
      t.string :child_4_relation
      t.string :child_4_first_name
      t.string :child_4_last_name
      t.string :child_4_chinese_name
      t.string :child_5_relation
      t.string :child_5_first_name
      t.string :child_5_last_name
      t.string :child_5_chinese_name
      t.attachment :photo
      t.integer :photo_number
      t.references :user, index: true
      t.boolean :verified
      t.boolean :disabled
      t.boolean :one_more_year
      t.string :key
      t.string :note

      t.timestamps
    end
  end
end
