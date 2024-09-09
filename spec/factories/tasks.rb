FactoryBot.define do
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on { "2025-02-18" }
    priority { "中" }
    status { "着手中" }
  end

  
  factory :first_task, class: Task do
    title { 'first_task' }
    content { 'testtest' }
    created_at { "2022-02-18" }
    deadline_on { "2022-02-18" }
    priority { "中" }
    status { "未着手" }
  end

  factory :second_task, class: Task do
    title { 'second_task' }
    content { 'testtest' }
    created_at { "2022-02-17" }
    deadline_on { "2022-02-17" }
    priority { "高" }
    status { "着手中" }
  end

  factory :third_task, class: Task do
    title { 'third_task' }
    content { 'testtest' }
    created_at { "2022-02-16" }
    deadline_on { "2022-02-16" }
    priority { "低" }
    status { "完了" }
  end
end
