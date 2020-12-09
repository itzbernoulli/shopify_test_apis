require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        store: "Store",
        nonce: "Nonce",
        access_token: "Access Token"
      ),
      User.create!(
        store: "Store",
        nonce: "Nonce",
        access_token: "Access Token"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", text: "Store".to_s, count: 2
    assert_select "tr>td", text: "Nonce".to_s, count: 2
    assert_select "tr>td", text: "Access Token".to_s, count: 2
  end
end
