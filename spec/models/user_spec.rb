require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  before do
    FactoryBot.create(:user)
  end

  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
      user = FactoryBot.build(:other_user, name: '')
      expect(user.valid?).to be false
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
      user = FactoryBot.build(:other_user, email: '')
      expect(user.valid?).to be false
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
      user = FactoryBot.build(:other_user, password: '', password_confirmation: '')
      expect(user.valid?).to be false
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
      user = FactoryBot.build(:other_user, email: 'test@test')
      expect(user.valid?).to be false
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
      user = FactoryBot.build(:other_user, password: 'test', password_confirmation: 'test')
      expect(user.valid?).to be false
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
      user = FactoryBot.build(:other_user)
      expect(user.valid?).to be true
      end
    end
  end
end

