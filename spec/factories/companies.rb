FactoryBot.define do
  factory :company do
    name { "MyString" }
    reqd_no_of_employees { 1 }
    parent_id { 1 }
  end
end
