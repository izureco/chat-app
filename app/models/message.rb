class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  # MessageテーブルとActive Storageテーブルの画像ファイルを紐づけた
  # has_one_attached :ファイル名 と書けば、"モデル名.ファイル名"でファイルにアクセスできる。
  # 例) Messageモデルのimageファイル : Message.imageと書けば、その画像の持つパラメータのキーにもできる。
  has_one_attached :image

  # ▼は、validationに条件分岐をつけている。
  # 私の理解 : 以下2つの項目を満たすとき、validation(検証)するという意味
  ## ❶ :content, presence: true -> "content"が空かどうか。
  ## ❷ unless: :was_attatched?  -> "画像"が添付されているかどうか。unlessだから、画像添付(戻り値がtrue)されていたらスルーされる?

  # <投稿できる場合>
  # ❶contentが空、❷画像が添付されている(戻り値がtrue)
  # ❶contentは空ではない、❷画像が添付されていない(戻り値がfalse)

  # <投稿できない場合> *❶❷どちらもtrue
  # ❶contentが空、❷画像が添付されていない(戻り値がfalse -> unlessがtrueになるということ)

  validates :content, presence: true, unless: :was_attached?

  def was_attached?
    self.image.attached?
  end

end
