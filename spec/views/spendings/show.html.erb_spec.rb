require 'rails_helper'

RSpec.describe "spendings/show", :type => :view do
  before(:each) do
    @spending = assign(:spending, Spending.create!(
      :description => "MyText",
      :amount => "9.99",
      :balance => "9.99",
      :image_url => "Image Url",
      :picture_file_name => "Picture File Name",
      :picture_content_type => "Picture Content Type",
      :picture_file_size => 1,
      :category => "Category",
      :account_item => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Image Url/)
    expect(rendered).to match(/Picture File Name/)
    expect(rendered).to match(/Picture Content Type/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(//)
  end
end
