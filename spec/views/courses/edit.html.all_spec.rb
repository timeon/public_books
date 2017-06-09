require 'rails_helper'

RSpec.describe "courses/edit", type: :view do
  before(:each) do
    @course = assign(:course, Course.create!(
      :category => nil,
      :medium => nil,
      :format => nil,
      :author => nil,
      :name => "MyString",
      :description => "MyText",
      :image => ""
    ))
  end

  it "renders the edit course form" do
    render

    assert_select "form[action=?][method=?]", course_path(@course), "post" do

      assert_select "input#course_category_id[name=?]", "course[category_id]"

      assert_select "input#course_medium_id[name=?]", "course[medium_id]"

      assert_select "input#course_format_id[name=?]", "course[format_id]"

      assert_select "input#course_author_id[name=?]", "course[author_id]"

      assert_select "input#course_name[name=?]", "course[name]"

      assert_select "textarea#course_description[name=?]", "course[description]"

      assert_select "input#course_image[name=?]", "course[image]"
    end
  end
end
