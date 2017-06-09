class AddSentAtToFamily < ActiveRecord::Migration
  def change
    add_column :families, :sent_at, :datetime
  end
end
