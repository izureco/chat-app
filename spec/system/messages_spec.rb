require 'rails_helper'

RSpec.describe 'メッセージ投稿機能', type: :system do
  before do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @room_user = FactoryBot.create(:room_user)
  end

  context '投稿に失敗したとき' do
    it '送る値が空の為、メッセージの送信に失敗する' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # DBに保存されていないことを確認する
      expect{find('input[name="commit"]').click}.to change{ Message.count }.by(0)

      # 元のページに戻ってくることを確認する
      # メッセージ入力ページに戻るために、部屋番号room_id(@room_user.room)を引数とする。
      expect(current_path).to eq room_messages_path(@room_user.room)
    end
  end

  context '投稿に成功したとき' do
    it 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 値をテキストフォームに入力する
      post = 'test'
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを確認する
      expect{find('input[name="commit"]').click}.to change{ Message.count }.by(1)

      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)

    end

    it '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      # Rails.root : Webアプリケーションのトップ階層のディレクトリまでの絶対パスを取得してくれる。
      #   Chat.appの絶対パスは、/Users/izumimasaki/Project/chat-app
      # Rails.root.join('パス情報')と記述すれば、▲の絶対パス+引数のパス情報を返してくれる。
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      # attach_file('画像アップロード用のinput要素のname属性'), 画像保存先のパス)
      attach_file('message[image]', image_path, make_visible: true)

      # 送信した値がDBに保存されていることを確認する
      expect{find('input[name="commit"]').click}.to change{ Message.count }.by(1)

      # 投稿一覧画面に遷移していることを確認する
      expect(current_path).to eq room_messages_path(@room_user.room)

      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector "img"

    end

    it 'テキストと画像の投稿に成功する' do
      # サインインする
      sign_in(@room_user.user)

      # 作成されたチャットルームへ遷移する
      click_on(@room_user.room.name)

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')

      # 画像選択フォームに画像を添付する
      attach_file('message[image]', image_path, make_visible: true)

      # 値をテキストフォームに入力する
      post = 'bbb'
      fill_in 'message_content', with: post

      # 送信した値がDBに保存されていることを確認する
      expect{find('input[name="commit"]').click}.to change{ Message.count }.by(1)

      # 送信した値がブラウザに表示されていることを確認する
      expect(page).to have_content(post)

      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector "img"
    end
  end
end

RSpec.describe 'チャットルームの削除機能', type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end

  it 'チャットルームを削除すると、関連するメッセージがすべて削除されている' do
    # サインインする
    sign_in(@room_user.user)

    # 作成されたチャットルームへ遷移する
    click_on(@room_user.room.name)

    # メッセージ情報を5つDBに追加する
    # messageのFactoryBotは、user,roomとassociation済
    # user_idとroom_idを、生成したmessageに紐づける必要がある。
    # 先に生成していた@room_userを使って、user_idとroom_idを取得
    FactoryBot.create_list(:message, 5, room_id: @room_user.room.id, user_id: @room_user.user.id)

    # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを確認する
    expect{find_link('チャットを終了する', href: room_path(@room_user.room)).click}.to change{ Message.count }.by(-5)
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path

  end
end