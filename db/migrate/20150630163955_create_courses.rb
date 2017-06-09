class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.references :category, index: true
      t.references :medium, index: true
      t.references :format, index: true
      t.references :author, index: true
      t.string :name
      t.string :english_name
      t.text :description
      t.string :source_url
      t.attachment :image

      t.timestamps
    end
  end
end
