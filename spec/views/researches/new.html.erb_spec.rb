require 'spec_helper'

describe "researches/new" do
  before(:each) do
    assign(:research, stub_model(Research,
      :lvl => 1,
      :technology_id => 1,
      :user_id => 1,
      :max_lvl => 1
    ).as_new_record)
  end

  it "renders new research form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => researches_path, :method => "post" do
      assert_select "input#research_lvl", :name => "research[lvl]"
      assert_select "input#research_technology_id", :name => "research[technology_id]"
      assert_select "input#research_user_id", :name => "research[user_id]"
      assert_select "input#research_max_lvl", :name => "research[max_lvl]"
    end
  end
end
