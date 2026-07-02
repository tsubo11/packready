class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:line]

  has_many :packing_lists, dependent: :destroy

  def self.from_omniauth(auth)
    # すでにLINE連携済みのユーザーを探す
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # メールアドレスが取得でき、かつ本人確認済みの場合のみ既存アカウントに紐付ける
    if auth.info.email && auth.extra.raw_info.email_verified
      user = User.find_by(email: auth.info.email)
      if user
        user.update!(provider: auth.provider, uid: auth.uid)
        return user
      end
    end
    
    #新規ユーザーを作成する
    User.create!(
      provider: auth.provider,
      uid: auth.uid,
      email: "#{auth.uid}@line.placeholder.com",
      password: Devise.friendly_token[0, 20]
    )
  end
end
