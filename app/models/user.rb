class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:line]

         has_many :packing_lists, dependent: :destroy

  def self.from_omniauth(auth)
    user = User.find_by(uid: auth.uid)
    if user
      return user
    elsif auth.info.email && (user = User.find_by(email: auth.info.email))
      user.update(provider: auth.provider, uid: auth.uid)
      return user
    else
      user = User.new(
        provider: auth.provider,
        uid: auth.uid,
        email: "#{auth.uid}@line.placeholder.com",
        password: Devise.friendly_token[0, 20]
      )
    end
    end
  end
end
