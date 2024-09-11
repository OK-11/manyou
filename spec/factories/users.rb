FactoryBot.define do
  factory :user do
    name { "test" }
    email { "test@test" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
  end

  factory :other_user , class: User do
    name { "test" }
    email { "test2@test" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end

end
