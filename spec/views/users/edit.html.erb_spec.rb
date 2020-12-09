require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      store: "MyString",
      nonce: "MyString",
      access_token: "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input[name=?]", "user[store]"

      assert_select "input[name=?]", "user[nonce]"

      assert_select "input[name=?]", "user[access_token]"
    end
  end
end
