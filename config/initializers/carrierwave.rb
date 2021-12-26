require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production? # 本番環境はS3にアップロード
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'car-theft-info' # バケット名
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/car-theft-info'
    config.fog_public = false
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials.dig(:aws, :s3, :access_key_id),
      aws_secret_access_key: Rails.application.credentials.dig(:aws, :s3, :secret_access_key),
      region: 'ap-northeast-1',
      # path_style: true
    }
  else # 開発環境はアプリ内にアップロード
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end
