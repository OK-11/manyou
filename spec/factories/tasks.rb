FactoryBot.define do
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する。' }
  end

  
  factory :first_task, class: Task do
    title { 'first_task' }
    content { 'testtest' }
    created_at { "2022-02-18" }
  end

  factory :second_task, class: Task do
    title { 'second_task' }
    content { 'testtest' }
    created_at { "2022-02-17" }
  end

  factory :third_task, class: Task do
    title { 'third_task' }
    content { 'testtest' }
    created_at { "2022-02-16" }
  end
end
