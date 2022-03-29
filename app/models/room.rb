class Room < ApplicationRecord
  # roomの削除(destroyアクション)を行うと、子のmessagesも一緒に削除する
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  # roomの削除(destroyアクション)を行うと、子のmessagesも一緒に削除する
  has_many :messages, dependent: :destroy

  validates :name, presence: true

end
