class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  # MessageテーブルとActive Storageテーブルの画像ファイルを紐づけた
  # has_one_attached :ファイル名 と書けば、"モデル名.ファイル名"でファイルにアクセスできる。
  # 例) Messageモデルのimageファイル : Message.imageと書けば、その画像の持つパラメータのキーにもできる。
  has_one_attached :image

  validates :content, presence: true
end
