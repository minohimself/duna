require 'spec_helper'

describe "researches/index" do
  before(:each) do
    assign(:researches, [
      stub_model(Research,
        :lvl => 1,
        :technology_id => 2,
        :user_id => 3,
        :max_lvl => 4
      ),
      stub_model(Research,
        :lvl => 1,
        :technology_id => 2,
        :user_id => 3,
        :max_lvl => 4
      )
    ])
  end

  it "renders a list of researches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
