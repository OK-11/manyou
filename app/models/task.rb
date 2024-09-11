class Task < ApplicationRecord
  validates :title , presence: {message: "can't be blank"}
  validates :content , presence: {message: "can't be blank"}
  validates :deadline_on , presence: {message: "終了期限を入力してください"}
  validates :priority , presence: {message: "優先度を入力してください"}
  validates :status , presence: {message: "ステータスを入力してください"}

  enum priority: {低: 0, 中: 1, 高: 2}
  enum status: {未着手: 0, 着手中: 1, 完了: 2}

  scope :search_status, -> (status) { where(status: status) }
  scope :search_title, -> (title) { where("title LIKE ?" , "%#{title}%") }

  belongs_to :user
end
