class AddPublicToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :public, :boolean, default:true
  end
end
