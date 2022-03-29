FactoryBot.define do
  factory :message do
    content      {Faker::Lorem.sentence}
    association :user
    association :room

    # 画像の自動生成を定義
    after(:build) do |message|
      message.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end