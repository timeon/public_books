class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :course, index: true
      t.string :name
      t.string :description
      t.text :body
      t.attachment :image

      t.timestamps
    end
  end
end
