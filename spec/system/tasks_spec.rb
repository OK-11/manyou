require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  let(:user) { User.create(name: "test", email: "test@test", password: "password", password_confirmation: "password", admin: false) }
  let!(:first_task) { FactoryBot.create(:first_task, user: user) }
  let!(:second_task) { FactoryBot.create(:second_task, user: user) }
  let!(:third_task) { FactoryBot.create(:third_task, user: user) }

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_session_path
        fill_in 'メールアドレス', with: 'test@test'
        fill_in 'パスワード', with: 'password'
        click_button "ログイン"
        click_link "タスクを登録する"
        fill_in "タイトル", with: "aaa"
        fill_in "内容", with: "bbb"
        find('#task_deadline').set("2024-12-31")
        select "中", from: "優先度"
        select "着手中", from: "ステータス"
        click_button "登録する"
        expect(page).to have_content "aaa"
      end
    end
  end

  describe '一覧表示機能' do
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'test@test'
      fill_in 'パスワード', with: 'password'
      click_button "ログイン"
      @task_list = all('.task_title')
      @task_list_text = @task_list.map{ |task| task.text }
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        expect(@task_list_text).to eq ["first_task" , "second_task" , "third_task"]
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        expect(@task_list_text[0]).to eq "first_task"
      end
    end

    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link "終了期限"
          expect(page).to have_selector('.task_title', count: 3)
          @task_list_sort = all('.task_title')
          @task_list_sort_text = @task_list_sort.map{ |task| task.text }
          expect(@task_list_sort_text).to eq ["third_task", "second_task", "first_task"]
        end
      end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link "優先度"
          expect(page).to have_selector('.task_title', count: 3)
          @task_list_sort = all('.task_title')
          @task_list_sort_text = @task_list_sort.map{ |task| task.text }
          expect(@task_list_sort_text).to eq ["second_task", "first_task", "third_task"]
        end
      end
    end

    describe '検索機能' do
      context 'scopeメソッドでタイトルのあいまい検索をした場合' do
        it "検索ワードを含むタスクが絞り込まれる" do
          # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
          # 検索されたテストデータの数を確認する
          fill_in "タイトル", with: "first"
          click_button "検索"
          expect(page).to have_content "first_task"
          expect(page).not_to have_content "second_task"
          @task_list_count = all('.task_title')
          expect(@task_list_count.length).to be 1
        end
      end
      context 'scopeメソッドでステータス検索をした場合' do
        it "ステータスに完全一致するタスクが絞り込まれる" do
          # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
          # 検索されたテストデータの数を確認する
          select "未着手", from: "ステータス"
          click_button "検索"
          expect(page).to have_content "first_task"
          expect(page).not_to have_content "second_task"
          @task_list_count = all('.task_title')
          expect(@task_list_count.length).to be 1
        end
      end
      context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
        it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
          # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
          # 検索されたテストデータの数を確認する
          select "未着手", from: "ステータス"
          fill_in "タイトル", with: "first"
          click_button "検索"
          expect(page).to have_content "first_task"
          expect(page).not_to have_content "second_task"
          @task_list_count = all('.task_title')
          expect(@task_list_count.length).to be 1
        end
      end
    end
  end

  describe '詳細表示機能' do
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'test@test'
      fill_in 'パスワード', with: 'password'
      click_button "ログイン"
    end
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
      click_link("詳細", match: :first)
      expect(page).to have_content "first_task"
      end
    end
  end
end