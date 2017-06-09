class AddEntryStyleToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :style, :string, default:''
  end
end
