class AddIsFileToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :is_file, :boolean, default:false
  end
end
