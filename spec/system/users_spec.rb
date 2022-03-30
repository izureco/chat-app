require 'rails_helper'

RSpec.describe 'ユーザーログイン機能', type: :system do
  it 'ログインしていない状態でトップページにアクセスした場合、サインインページに移動する' do
    # トップページに遷移する
    visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    # ▲共通applicationコントローラー部に、authenticatedメソッド(未ログインユーザーはsign_upに飛ばす)を入れているから。
    expect(current_path).to eq new_user_session_path

  end

  it 'ログインに成功し、トップページに遷移する' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)        
    # サインインページへ移動する
    visit new_user_session_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq new_user_session_path
    # すでに保存されているユーザーのemailとpasswordを入力する
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    # ログインボタンをクリックする
    # find('input[name="commit"]').click
    click_on ('Log in')
    # トップページに遷移していることを確認する
    expect(current_path).to eq root_path
  end

  it 'ログインに失敗し、再びサインインページに戻ってくる' do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
    # トップページに遷移する
    visit root_path
    # ログインしていない場合、サインインページに遷移していることを確認する
    expect(current_path).to eq new_user_session_path
    # 誤ったユーザー情報を入力する
    user_email = 'aaa'
    user_pass = 'ggg'
    fill_in 'user_email', with: user_email 
    fill_in 'user_password', with: user_pass 
    # ログインボタンをクリックする
    click_on ('Log in')
    # サインインページに戻ってきていることを確認する
    expect(current_path).to eq new_user_session_path

  end
end