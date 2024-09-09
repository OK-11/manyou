require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  
  before do
    FactoryBot.create(:first_task)
    FactoryBot.create(:second_task)
    FactoryBot.create(:third_task)
  end
  

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
    before do
      FactoryBot.create(:task)
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

    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link "終了期限"
          expect(page).to have_selector('.task_title', count: 4)
          @task_list_sort = all('.task_title')
          @task_list_sort_text = @task_list_sort.map{ |task| task.text }
          expect(@task_list_sort_text).to eq ["third_task", "second_task", "first_task", "書類作成"]
        end
      end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          click_link "優先度"
          expect(page).to have_selector('.task_title', count: 4)
          @task_list_sort = all('.task_title')
          @task_list_sort_text = @task_list_sort.map{ |task| task.text }
          expect(@task_list_sort_text).to eq ["second_task", "first_task", "書類作成", "third_task"]
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
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task)
        visit task_path(task)
        expect(page).to have_content "書類作成"
       end
     end
  end

end