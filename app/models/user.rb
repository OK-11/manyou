class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: { message: "メールアドレスを入力してください" }
  validates :email, uniqueness: { message: "メールアドレスはすでに使用されています" }

  validates :password, presence: { message: "パスワードを入力してください" }
  validates :password, length: { minimum: 6, message: "パスワードは6文字以上で入力してください" }
  

  has_many :tasks , dependent: :destroy



  def admin_user_cannot_destroy
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, "管理者が0人になるため削除できません")
    end
  end

  before_destroy :admin_user_cannot_destroy

  def admin_user_cannot_update
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, "管理者が0人になるため権限を変更できません")
    end
  end

end
