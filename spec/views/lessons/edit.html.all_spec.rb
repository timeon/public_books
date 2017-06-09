require 'rails_helper'

RSpec.describe "lessons/edit", type: :view do
  before(:each) do
    @lesson = assign(:lesson, Lesson.create!(
      :course => nil,
      :name => "MyString",
      :description => "MyString",
      :body => "MyText",
      :image => ""
    ))
  end

  it "renders the edit lesson form" do
    render

    assert_select "form[action=?][method=?]", lesson_path(@lesson), "post" do

      assert_select "input#lesson_course_id[name=?]", "lesson[course_id]"

      assert_select "input#lesson_name[name=?]", "lesson[name]"

      assert_select "input#lesson_description[name=?]", "lesson[description]"

      assert_select "textarea#lesson_body[name=?]", "lesson[body]"

      assert_select "input#lesson_image[name=?]", "lesson[image]"
    end
  end
end
