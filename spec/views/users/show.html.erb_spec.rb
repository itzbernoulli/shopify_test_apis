require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      store: "Store",
      nonce: "Nonce",
      access_token: "Access Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Store/)
    expect(rendered).to match(/Nonce/)
    expect(rendered).to match(/Access Token/)
  end
end
