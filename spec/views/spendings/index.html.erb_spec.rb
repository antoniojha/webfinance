require 'rails_helper'

RSpec.describe "spendings/index", :type => :view do
  before(:each) do
    assign(:spendings, [
      Spending.create!(
        :description => "MyText",
        :amount => "9.99",
        :balance => "9.99",
        :image_url => "Image Url",
        :picture_file_name => "Picture File Name",
        :picture_content_type => "Picture Content Type",
        :picture_file_size => 1,
        :category => "Category",
        :account_item => nil
      ),
      Spending.create!(
        :description => "MyText",
        :amount => "9.99",
        :balance => "9.99",
        :image_url => "Image Url",
        :picture_file_name => "Picture File Name",
        :picture_content_type => "Picture Content Type",
        :picture_file_size => 1,
        :category => "Category",
        :account_item => nil
      )
    ])
  end

  it "renders a list of spendings" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Image Url".to_s, :count => 2
    assert_select "tr>td", :text => "Picture File Name".to_s, :count => 2
    assert_select "tr>td", :text => "Picture Content Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
