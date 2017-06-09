class AddSourceUrlToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :source_url, :string
  end
end
