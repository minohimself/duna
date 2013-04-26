require 'spec_helper'

describe "researches/show" do
  before(:each) do
    @research = assign(:research, stub_model(Research,
      :lvl => 1,
      :technology_id => 2,
      :user_id => 3,
      :max_lvl => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
  end
end
