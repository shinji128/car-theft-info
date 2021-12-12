class PostsController < ApplicationController # rubocop:disable Metrics/ClassLength
  skip_before_action :require_login, only: %i[index show]

  def index
    @posts = Post.all.includes(:user, :images).order(created_at: :desc)
  end

  def new
    @form = PostForm.new
  end

  def create
    @form = PostForm.new(post_params)
    if @form.save
      message = { type: 'flex', altText: '盗難車両', contents: line_carousel(@form) }
      client.broadcast(message)
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
    @form = PostForm.new(post: @post)
  end

  def update
    @post = current_user.posts.find(params[:id])
    @form = PostForm.new(post_params, post: @post)

    if @form.update
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:car_name, :car_model, :car_number, :stole_time,
                                 :stole_location, :contact, { images: [] }, :image_cache)
          .merge(user_id: current_user.id)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.credentials.line[:line_channel_secret]
      config.channel_token = Rails.application.credentials.line[:line_channel_token]
    end
  end

  def line_carousel(form)
    bubbles = []
    form.post.images.each_with_index do |img, i|
      if i.zero?
        bubbles.push line_bubble(form)
      else
        bubbles.push image_bubble(img.image.url)
      end
    end
    { type: 'carousel', contents: bubbles }
  end

  def line_bubble(form)
    {
      type: 'bubble',
      hero: line_hero(form),
      body: line_body(form),
      footer: line_footer(form)
    }
  end

  def line_hero(form)
    {
      type: 'image',
      url: form.post.images[0].image.url.to_s,
      size: 'full', aspectRatio: '4:3', aspectMode: 'cover',
      action: { type: 'uri', uri: form.post.images[0].image.url.to_s }
    }
  end

  def line_body(form)
    {
      type: 'box', layout: 'vertical',
      contents: [
        {
          type: 'text', text: "#{form.car_name}が盗まれました",
          size: 'xxl', wrap: true, weight: 'bold'
        },
        {
          type: 'box', layout: 'vertical', margin: 'lg', spacing: 'sm',
          contents: form.line_body_contents
        },
        { type: 'separator' }
      ]
    }
  end

  def line_footer(form)
    {
      type: 'box', layout: 'vertical', spacing: 'sm',
      contents: [
        {
          type: 'button', style: 'link', height: 'sm',
          action: {
            type: 'uri', label: '盗難情報詳細ページ',
            uri: "https://car-theft-info.herokuapp.com/posts/#{form.post.id}"
          }
        },
        { type: 'spacer', size: 'sm' }
      ],
      flex: 0
    }
  end

  def image_bubble(img)
    {
      type: 'bubble',
      body: {
        type: 'box', layout: 'vertical',
        contents: [
          {
            type: 'image', url: img.to_s, size: 'full',
            aspectMode: 'cover', aspectRatio: '1:1', gravity: 'center',
            action: { type: 'uri', label: 'action', uri: img.to_s }
          }
        ],
        paddingAll: '0px'
      }
    }
  end
end
