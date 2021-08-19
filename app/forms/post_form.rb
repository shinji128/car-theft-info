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

  def text
    '車名:' + car_name + "\n" +
      '車の型式:' + car_model + "\n" +
      'ナンバープレート:' + car_number + "\n" +
      '盗難時刻:' + stole_time.to_s + "\n" +
      '盗難場所:' + stole_location + "\n" +
      '目撃情報連絡先:' + contact
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
