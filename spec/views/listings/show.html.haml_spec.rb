require 'spec_helper'

describe "listings/show" do
  before(:each) do
    @listing = assign(:listing, stub_model(Listing,
      :index => "Index",
      :show => "Show",
      :new => "New",
      :create => "Create",
      :edit => "Edit",
      :update => "Update",
      :destroy => "Destroy"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Index/)
    rendered.should match(/Show/)
    rendered.should match(/New/)
    rendered.should match(/Create/)
    rendered.should match(/Edit/)
    rendered.should match(/Update/)
    rendered.should match(/Destroy/)
  end
end
