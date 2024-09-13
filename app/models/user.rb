class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  validates :password, presence: true
  validates :password, length: { minimum: 6, message: "パスワードは6文字以上で入力してください" }
  

  has_many :tasks , dependent: :destroy
  has_many :labels

  before_destroy :admin_user_cannot_destroy
  before_update :admin_user_cannot_update


  def admin_user_cannot_destroy
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, "管理者が0人になるため削除できません")
      throw :abort
    end
  end

  def admin_user_cannot_update
    check = attribute_change_to_be_saved("admin")
    
    if User.where(admin: true).count == 1  && check.present? && check[0] == true
      errors.add(:base, "管理者が0人になるため権限を変更できません")
      throw :abort
    end
  end

end
