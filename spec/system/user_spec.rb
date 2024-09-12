require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do

  before do
    @user = FactoryBot.create(:other_user)
    @admin = FactoryBot.create(:user)
  end
  
  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in '名前', with: 'test'
        fill_in 'メールアドレス', with: 'test@test0'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '登録する'
        expect(page).to have_current_path(tasks_path)
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_current_path(new_session_path)
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'test2@test'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン' 
    end
    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content "ログインしました"
      end
      it '自分の詳細画面にアクセスできる' do
        click_link 'アカウント設定'
        expect(page).to have_current_path(user_path(@user))

      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(@admin)
        expect(page).to have_current_path(tasks_path)
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_current_path(new_session_path)
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe '管理者機能' do
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'test@test'
      fill_in 'パスワード', with: 'password'
      click_button "ログイン"
    end
    context '管理者がログインした場合' do
      it 'ユーザ一覧画面にアクセスできる' do
        click_link "ユーザ一覧"
        expect(page).to have_current_path(admin_users_path)
      end
      it '管理者を登録できる' do
        click_link "ユーザを登録する"
        expect(page).to have_current_path(new_admin_user_path)
        fill_in '名前', with: 'admin'
        fill_in 'メールアドレス', with: 'test@test99'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button "登録する"
        expect(page).to have_current_path(admin_users_path)
        expect(page).to have_content "admin"
      end
      it 'ユーザ詳細画面にアクセスできる' do
        click_link("詳細", match: :first)
        expect(page).to have_current_path(admin_user_path(@user))
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        click_link("編集", match: :first)
        expect(page).to have_current_path(edit_admin_user_path(@user))
        fill_in '名前', with: 'kei'
        fill_in 'メールアドレス', with: 'test@test99'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button "登録する"
        expect(page).to have_content "kei"
      end
      it 'ユーザを削除できる' do
        click_link("削除", match: :first)
        page.accept_alert('本当に削除してもよろしいですか？')
        expect(page).to have_current_path(admin_users_path)
        expect(page).to have_no_content "test2@test"
      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        click_link "ログアウト"
        fill_in 'メールアドレス', with: 'test2@test'
        fill_in 'パスワード', with: 'password'
        click_button "ログイン"
        visit admin_users_path
        expect(page).to have_content "管理者以外アクセスできません"
      end
    end
  end

end