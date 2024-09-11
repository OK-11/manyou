class User < ApplicationRecord
  has_secure_password

  validates :name, presence: { message: "名前を入力してください" }
  validates :email, presence: { message: "メールアドレスを入力してください" }
  validates :email, uniqueness: { message: "メールアドレスはすでに使用されています" }

  validates :password, presence: { message: "パスワードを入力してください" }
  validates :password, length: { minimum: 6, message: "パスワードは6文字以上で入力してください" }
  validate :passwords_match

  has_many :tasks , dependent: :destroy






  def admin_user_cannot_destroy
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, "管理者が0人になるため削除できません")
      throw :abort
    end
  end

  def admin_user_cannot_update
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, "管理者が0人になるため権限を変更できません")
      throw :abort
    end
  end


  private
  def passwords_match
    if password != password_confirmation
      errors.add(:password_confirmation, "パスワード（確認）とパスワードの入力が一致しません")
    end
  end
end
