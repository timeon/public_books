require 'rails_helper'

RSpec.describe "lessons/new", type: :view do
  before(:each) do
    assign(:lesson, Lesson.new(
      :course => nil,
      :name => "MyString",
      :description => "MyString",
      :body => "MyText",
      :image => ""
    ))
  end

  it "renders new lesson form" do
    render

    assert_select "form[action=?][method=?]", lessons_path, "post" do

      assert_select "input#lesson_course_id[name=?]", "lesson[course_id]"

      assert_select "input#lesson_name[name=?]", "lesson[name]"

      assert_select "input#lesson_description[name=?]", "lesson[description]"

      assert_select "textarea#lesson_body[name=?]", "lesson[body]"

      assert_select "input#lesson_image[name=?]", "lesson[image]"
    end
  end
end
