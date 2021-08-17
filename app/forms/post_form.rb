class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend CarrierWave::Mount
  mount_uploader :image, ImageUploader

  attribute :car_name, :string
  attribute :car_model, :string
  attribute :car_number, :string
  attribute :stole_time, :datetime
  attribute :stole_location, :string
  attribute :contact, :string
  attribute :images
  attribute :user_id, :integer

  def save
    return false if invalid?

    post = Post.new(post_params)
    post.save

    images.each do |image|
      post.images.create!(image: image)
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
end
