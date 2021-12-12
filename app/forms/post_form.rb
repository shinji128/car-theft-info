class PostForm # rubocop:disable Metrics/ClassLength
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
  attribute :post

  validates :car_name, presence: true, length: { maximum: 50 }
  validates :car_number, presence: true, length: { maximum: 50 }
  validates :stole_location, presence: true
  validates :images, presence: true

  validate :check_image
  validate :image_count

  delegate :persisted?, to: :@post

  def initialize(attributes = nil, post: Post.new)
    @post = post
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      self.post = Post.new(post_params)
      post.save

      images.each do |image|
        post.images.create!(image: image)
      end
    end
    true
  end

  def update
    ActiveRecord::Base.transaction do
      images.each do |image|
        @post.images.create(image: image)
      end
      @post.update!(post_params)
    end
  end

  def to_model
    @post
  end

  def line_body_contents # rubocop:disable Metrics/MethodLength
    tags = %w[car_name car_model car_number stole_location contact stole_time]
    tags.map do |tag|
      {
        type: 'box', layout: 'baseline', spacing: 'sm',
        contents: [
          {
            type: 'text', text: I18n.t("activerecord.attributes.post.#{tag}"),
            size: 'sm', color: '#aaaaaa', flex: 2
          },
          {
            type: 'text', text: post.attribute_in_database(tag),
            wrap: true, color: '#666666', size: 'sm', flex: 5
          }
        ]
      }
    end
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

  def default_attributes
    {
      car_name: @post.car_name,
      car_model: @post.car_model,
      car_number: @post.car_number,
      stole_location: @post.stole_location,
      contact: @post.contact,
      stole_time: @post.stole_time,
      user_id: @post.user_id,
      images: @post.images
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

    errors.add(:images, 'は5枚までです') if images.count >= 6
  end
end
