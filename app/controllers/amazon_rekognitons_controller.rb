class AmazonRekognitonsController < ApplicationController
  skip_before_action :require_login, only: %i[test]

  def test
    # puts 'テスト送信'
    result = client.detect_labels({
      image: {
        s3_object: {
          bucket: 'car-theft-info',
          name: 'uploads/image/image/15/NAロードスター.jpeg'
        }
      }
    })
    result.labels.each do |label|
      puts("#{label.name} #{label.confidence}")
    end
    redirect_to root_path
  end

  def client
    @client = Aws::Rekognition::Client.new(
      region: 'ap-northeast-1',
      access_key_id: Rails.application.credentials.dig(:aws, :rekognition, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:aws, :rekognition, :secret_access_key)
    )
  end
end
