require 'rails_helper'

RSpec.describe "spendings/new", :type => :view do
  before(:each) do
    assign(:spending, Spending.new(
      :description => "MyText",
      :amount => "9.99",
      :balance => "9.99",
      :image_url => "MyString",
      :picture_file_name => "MyString",
      :picture_content_type => "MyString",
      :picture_file_size => 1,
      :category => "MyString",
      :account_item => nil
    ))
  end

  it "renders new spending form" do
    render

    assert_select "form[action=?][method=?]", spendings_path, "post" do

      assert_select "textarea#spending_description[name=?]", "spending[description]"

      assert_select "input#spending_amount[name=?]", "spending[amount]"

      assert_select "input#spending_balance[name=?]", "spending[balance]"

      assert_select "input#spending_image_url[name=?]", "spending[image_url]"

      assert_select "input#spending_picture_file_name[name=?]", "spending[picture_file_name]"

      assert_select "input#spending_picture_content_type[name=?]", "spending[picture_content_type]"

      assert_select "input#spending_picture_file_size[name=?]", "spending[picture_file_size]"

      assert_select "input#spending_category[name=?]", "spending[category]"

      assert_select "input#spending_account_item_id[name=?]", "spending[account_item_id]"
    end
  end
end
