class AddVerifiedAtToFamily < ActiveRecord::Migration
  def change
    add_column :families, :verified_at, :datetime
  end
end
