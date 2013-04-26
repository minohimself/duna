require 'spec_helper'

describe "technologies/edit" do
  before(:each) do
    @technology = assign(:technology, stub_model(Technology,
      :name => "MyString",
      :description => "MyText",
      :price => ""
    ))
  end

  it "renders the edit technology form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => technologies_path(@technology), :method => "post" do
      assert_select "input#technology_name", :name => "technology[name]"
      assert_select "textarea#technology_description", :name => "technology[description]"
      assert_select "input#technology_price", :name => "technology[price]"
    end
  end
end
