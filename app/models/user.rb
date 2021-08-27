class User < ApplicationRecord
  has_secure_password
  has_many :friends
  has_one_attached :image
  validates :userid, presence: {message: "は必ず入力してください"}, uniqueness: {message: "%{value}はすでに使用されています"}
end
