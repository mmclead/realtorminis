require 'spec_helper'

describe "listings/index" do
  before(:each) do
    assign(:listings, [
      stub_model(Listing,
        :index => "Index",
        :show => "Show",
        :new => "New",
        :create => "Create",
        :edit => "Edit",
        :update => "Update",
        :destroy => "Destroy"
      ),
      stub_model(Listing,
        :index => "Index",
        :show => "Show",
        :new => "New",
        :create => "Create",
        :edit => "Edit",
        :update => "Update",
        :destroy => "Destroy"
      )
    ])
  end

  it "renders a list of listings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Index".to_s, :count => 2
    assert_select "tr>td", :text => "Show".to_s, :count => 2
    assert_select "tr>td", :text => "New".to_s, :count => 2
    assert_select "tr>td", :text => "Create".to_s, :count => 2
    assert_select "tr>td", :text => "Edit".to_s, :count => 2
    assert_select "tr>td", :text => "Update".to_s, :count => 2
    assert_select "tr>td", :text => "Destroy".to_s, :count => 2
  end
end
