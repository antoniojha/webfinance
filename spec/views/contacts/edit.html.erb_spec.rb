require 'rails_helper'

RSpec.describe "contacts/edit", :type => :view do
  before(:each) do
    @contact = assign(:contact, Contact.create!(
      :title => "MyString",
      :issue_content => "MyText",
      :email => "MyString"
    ))
  end

  it "renders the edit contact form" do
    render

    assert_select "form[action=?][method=?]", contact_path(@contact), "post" do

      assert_select "input#contact_title[name=?]", "contact[title]"

      assert_select "textarea#contact_issue_content[name=?]", "contact[issue_content]"

      assert_select "input#contact_email[name=?]", "contact[email]"
    end
  end
end
