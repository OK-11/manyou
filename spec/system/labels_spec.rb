require 'rails_helper'
 RSpec.describe 'ラベル管理機能', type: :system do
  let(:user) { User.create(name: "test", email: "test@test", password: "password", password_confirmation: "password", admin: false) }
  let!(:label) { Label.create(name: "test" , user: user) }
  let!(:admin) { User.create(name: "admin", email: "admin@admin", password: "password", password_confirmation: "password", admin: true) }

   describe '登録機能' do
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'test@test'
      fill_in 'パスワード', with: 'password'
      click_button "ログイン"
    end
     context 'ラベルを登録した場合' do
       it '登録したラベルが表示される' do
         click_link "ラベルを登録する"
         fill_in "名前", with: "test"
         click_button "登録する"
         expect(page).to have_content "test"
       end
     end
   end
   describe '一覧表示機能' do
    before do
      visit new_session_path
      fill_in 'メールアドレス', with: 'test@test'
      fill_in 'パスワード', with: 'password'
      click_button "ログイン"
    end
     context '一覧画面に遷移した場合' do
       it '登録済みのラベル一覧が表示される' do
         click_link "ラベル一覧"
         expect(page).to have_content "test"
       end
     end
   end
 end