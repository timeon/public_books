class AddAuthorToLesson < ActiveRecord::Migration
  def change
    add_reference :lessons, :author, index: true
  end
end
