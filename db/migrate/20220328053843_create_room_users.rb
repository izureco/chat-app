class CreateRoomUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :room_users do |t|
      # references : 外部キーカラムの定義. userと書けば, user_idカラムが生成される。
      # foreign_key : 外部キー制約をつける
      # 外部キー制約 (1) : 存在しない値を外部キーに設定できない
      # 外部キー制約 (2) : 親レコードのカラムを削除するためには、まず子レコードを削除しなければならない。
      t.references  :user, foreign_key: true
      t.references  :room, foreign_key: true
      t.timestamps
    end
  end
end
