class AddFamilyNameToFamily < ActiveRecord::Migration
  def change
    add_column :families, :family_name, :string
  end
end
