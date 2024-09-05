# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'faker'

50.times do
  Task.create(
    title: Faker::Lorem.sentence(word_count: 3),  # 例: "Sample Task Title"
    content: Faker::Lorem.paragraph,             # 例: "This is the content of the task."
    created_at: Faker::Time.backward(days: 365), # 例: 過去 1 年間のランダムな時間
    updated_at: Faker::Time.backward(days: 30)   # 例: 過去 30 日間のランダムな時間
  )
end