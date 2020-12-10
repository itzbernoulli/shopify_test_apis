FactoryBot.define do
  factory :customer do
    user { nil }
    first_name { "MyString" }
    last_name { "MyString" }
    Email { "MyString" }
    Company { "MyString" }
    address1 { "MyString" }
    address2 { "MyString" }
    city { "MyString" }
    province { "MyString" }
    province_code { "MyString" }
    country { "MyString" }
    country_code { "MyString" }
    Zip { "MyString" }
    phone { "MyString" }
    accepts_marketing { "MyString" }
    total_spent { 1.5 }
    total_orders { "MyString" }
    integer { "MyString" }
    Tags { "MyString" }
    Note { "MyString" }
    tax_exempt { "MyString" }
  end
end
