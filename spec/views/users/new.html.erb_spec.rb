require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      store: "MyString",
      nonce: "MyString",
      access_token: "MyString"
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input[name=?]", "user[store]"

      assert_select "input[name=?]", "user[nonce]"

      assert_select "input[name=?]", "user[access_token]"
    end
  end
end
