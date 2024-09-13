require 'rails_helper'

 RSpec.describe 'ラベルモデル機能', type: :model do
   describe 'バリデーションのテスト' do
     context 'ラベルの名前が空文字の場合' do
       it 'バリデーションに失敗する' do
        user = User.create(name: "test", email: "test@test", password: "password", password_confirmation: "password", admin: false)
        label = user.labels.build(name: "")
        expect(label.valid?).to be false
       end
     end

     context 'ラベルの名前に値があった場合' do
       it 'バリデーションに成功する' do
        user = User.create(name: "test", email: "test@test", password: "password", password_confirmation: "password", admin: false)
        label = user.labels.build(name: "test")
        expect(label.valid?).to be true
       end
     end
   end
 end