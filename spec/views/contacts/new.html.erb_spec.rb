require 'rails_helper'

RSpec.describe "contacts/new", :type => :view do
  before(:each) do
    assign(:contact, Contact.new(
      :title => "MyString",
      :issue_content => "MyText",
      :email => "MyString"
    ))
  end

  it "renders new contact form" do
    render

    assert_select "form[action=?][method=?]", contacts_path, "post" do

      assert_select "input#contact_title[name=?]", "contact[title]"

      assert_select "textarea#contact_issue_content[name=?]", "contact[issue_content]"

      assert_select "input#contact_email[name=?]", "contact[email]"
    end
  end
end
