require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  before do
    @user = User.create(name: "test", email: "test@test", password: "password", password_confirmation: "password", admin: false)
  end
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = @user.tasks.new(title: "", content: "test", deadline_on: "2022-02-18", priority: "中", status: "着手中")
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = @user.tasks.new(title: "test", content: "", deadline_on: "2022-02-18", priority: "中", status: "着手中")
        expect(task.valid?).to be false
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = @user.tasks.new(title: "test", content: "testtest", deadline_on: "2022-02-18", priority: "中", status: "着手中")
        expect(task.valid?).to be true
      end
    end
  end
end
