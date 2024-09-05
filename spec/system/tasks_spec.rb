require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in "タイトル", with: "test"
        fill_in "内容", with: "testtest"
        click_button "登録する"
        expect(page).to have_content "testtest"
      end
    end
  end

  describe '一覧表示機能' do
    let!(:task) { FactoryBot.create(:task) }
    before do
      FactoryBot.create(:first_task)
      FactoryBot.create(:second_task)
      FactoryBot.create(:third_task)
      visit tasks_path
      @task_list = all('.task_title')
      @task_list_text = @task_list.map{ |task| task.text }
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        expect(@task_list_text).to eq ["書類作成" , "first_task" , "second_task" , "third_task"]
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        expect(@task_list_text[0]).to eq "書類作成"
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task)
        expect(page).to have_content "書類作成"
       end
     end
  end
end