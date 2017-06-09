class AddSentToFamily < ActiveRecord::Migration
  def change
    add_column :families, :sent, :boolean, default:false
  end
end
