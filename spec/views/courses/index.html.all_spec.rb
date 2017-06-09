require 'rails_helper'

RSpec.describe "courses/index", type: :view do
  before(:each) do
    assign(:courses, [
      Course.create!(
        :category => nil,
        :medium => nil,
        :format => nil,
        :author => nil,
        :name => "Name",
        :description => "MyText",
        :image => ""
      ),
      Course.create!(
        :category => nil,
        :medium => nil,
        :format => nil,
        :author => nil,
        :name => "Name",
        :description => "MyText",
        :image => ""
      )
    ])
  end

  it "renders a list of courses" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
