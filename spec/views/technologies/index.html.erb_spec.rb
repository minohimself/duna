require 'spec_helper'

describe "technologies/index" do
  before(:each) do
    assign(:technologies, [
      stub_model(Technology,
        :name => "Name",
        :description => "MyText",
        :price => ""
      ),
      stub_model(Technology,
        :name => "Name",
        :description => "MyText",
        :price => ""
      )
    ])
  end

  it "renders a list of technologies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
