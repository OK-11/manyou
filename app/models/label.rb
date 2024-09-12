class Label < ApplicationRecord
  validates :name, presence: {message: "名前を入力してください"}

  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  belongs_to :user
end
