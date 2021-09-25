class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :car_name, :string
  attribute :car_model, :string
  attribute :car_number, :string
  attribute :stole_time, :datetime
  attribute :stole_location, :string
  attribute :contact, :string
  attribute :images
  attribute :user_id, :integer
  attribute :post

  validates :car_name, presence: true, length: { maximum: 50 }
  validates :car_number, presence: true, length: { maximum: 50 }
  validates :stole_location, presence: true
  validates :images, presence: true

  validate :check_image
  validate :image_count

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      self.post = Post.new(post_params) # newがcreateじゃね？
      post.save

      images.each do |image|
        post.images.create!(image: image)
      end
    end
    true
  end

  private

  def post_params
    {
      car_name: car_name,
      car_model: car_model,
      car_number: car_number,
      stole_location: stole_location,
      contact: contact,
      stole_time: stole_time,
      user_id: user_id
    }
  end

  def check_image
    return false if images.blank?

    extension_allowlist = %w[image/jpg image/jpeg image/png]
    images&.each do |image|
      if !extension_allowlist.include?(image.content_type)
        errors.add(:images, 'は jpg/jpeg/png のみアップロードできます')
      elsif image.size > 3.megabyte
        errors.add(:images, '3MBまでアップロードできます')
      end
    end
  end

  def image_count
    return false if images.blank?

    errors.add('画像は5枚までです') if images.count >= 6
  end
end
