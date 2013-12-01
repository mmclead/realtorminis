require 'spec_helper'

describe "listings/edit" do
  before(:each) do
    @listing = assign(:listing, stub_model(Listing,
      :index => "MyString",
      :show => "MyString",
      :new => "MyString",
      :create => "MyString",
      :edit => "MyString",
      :update => "MyString",
      :destroy => "MyString"
    ))
  end

  it "renders the edit listing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", listing_path(@listing), "post" do
      assert_select "input#listing_index[name=?]", "listing[index]"
      assert_select "input#listing_show[name=?]", "listing[show]"
      assert_select "input#listing_new[name=?]", "listing[new]"
      assert_select "input#listing_create[name=?]", "listing[create]"
      assert_select "input#listing_edit[name=?]", "listing[edit]"
      assert_select "input#listing_update[name=?]", "listing[update]"
      assert_select "input#listing_destroy[name=?]", "listing[destroy]"
    end
  end
end
