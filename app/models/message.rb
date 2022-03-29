class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  # MessageテーブルとActive Storageテーブルの画像ファイルを紐づけた
  # has_one_attached :ファイル名 と書けば、"モデル名.ファイル名"でファイルにアクセスできる。
  # 例) Messageモデルのimageファイル : Message.imageと書けば、その画像の持つパラメータのキーにもできる。
  has_one_attached :image

  # ▼は、2つの項目がtrueのとき、validate(制限)するという意味
  ## ❶ :content, presence: true -> "チャット"が空である
  ## ❷ unless: :was_attatched?  -> "画像"が添付されていない(was_attachedの戻り値がfalse)
  # つまり、❶が満たされていても、❷で画像が添付されていれば投稿は可能。逆もまた然り
  validates :content, presence: true, unless: :was_attached?

  def was_attached?
    self.image.attached?
  end

end
