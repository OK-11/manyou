# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'faker'

admin = User.create(name: "admin2", email: "admin2@admin", password: "password", password_confirmation: "password", admin: true)
user = User.create(name: "test", email: "test@test", password: "password", password_confirmation: "password", admin: false)

50.times do
  Task.create(
    title: Faker::Lorem.sentence(word_count: 3),  # 例: "Sample Task Title"
    content: Faker::Lorem.paragraph,             # 例: "This is the content of the task."
    created_at: Faker::Time.backward(days: 365), # 例: 過去 1 年間のランダムな時間
    deadline_on: Faker::Date.between(from: 6.months.ago, to: 6.months.from_now), # 例: 今日から 30 日後のランダムな日付
    priority: Faker::Number.between(from: 0, to: 2),
    status: Faker::Number.between(from: 0, to: 2),
    user_id: user.id
  )

  Task.create(
    title: Faker::Lorem.sentence(word_count: 3),  # 例: "Sample Task Title"
    content: Faker::Lorem.paragraph,             # 例: "This is the content of the task."
    created_at: Faker::Time.backward(days: 365), # 例: 過去 1 年間のランダムな時間
    deadline_on: Faker::Date.between(from: 6.months.ago, to: 6.months.from_now), # 例: 今日から 30 日後のランダムな日付
    priority: Faker::Number.between(from: 0, to: 2),
    status: Faker::Number.between(from: 0, to: 2),
    user_id: admin.id
  )
end

