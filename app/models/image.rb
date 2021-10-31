class Image < ApplicationRecord
  belongs_to :post

  mount_uploader :image, ImageUploader

  def url
    image.url
  end
end
