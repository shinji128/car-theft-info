class PostsController < ApplicationController
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
      message = { type: 'flex', altText: '盗難車両', contents: set_bubble(@form) }
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
                                 :stole_location, :contact, { images: [] })
          .merge(user_id: current_user.id)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.credentials.line[:line_channel_secret]
      config.channel_token = Rails.application.credentials.line[:line_channel_token]
    end
  end

  def set_bubble(form)
    {
      type: 'bubble',
      hero: set_hero(form),
      body: set_body(form),
      footer: set_footer(form)
    }
  end

  def set_hero(form)
    {
      type: 'image',
      url: form.post.images[0].image.url.to_s,
      size: 'full',
      aspectRatio: '4:3',
      aspectMode: 'cover',
      action: {
        type: 'uri',
        uri: form.post.images[0].image.url.to_s
      }
    }
  end

  def set_body(form)
    {
      type: 'box',
      layout: 'vertical',
      contents: [
        {
          type: 'text',
          text: "#{form.car_name}が盗まれました",
          size: 'xxl',
          wrap: true,
          weight: 'bold'
        },
        {
          type: 'box',
          layout: 'vertical',
          margin: 'lg',
          spacing: 'sm',
          contents: form.set_body_contents
          # {
          #   type: 'box',
          #   layout: 'baseline',
          #   spacing: 'sm',
          #   contents: form.hoge
          # {
          #   type: 'text',
          #   text: t('activerecord.attributes.post.car_name'),
          #   size: 'sm',
          #   color: '#aaaaaa',
          #   flex: 2
          # },
          # form.hoge
          # {
          #   type: 'text',
          #   text: form.car_name,
          #   wrap: true,
          #   color: '#666666',
          #   size: 'sm',
          #   flex: 5
          # }
          # ]
          # },
          # {
          #   type: 'box',
          #   layout: 'baseline',
          #   spacing: 'sm',
          #   contents: [
          #     {
          #       type: 'text',
          #       text: '型式',
          #       size: 'sm',
          #       color: '#aaaaaa',
          #       flex: 2
          #     },
          #     {
          #       type: 'text',
          #       text: form.car_model,
          #       wrap: true,
          #       color: '#666666',
          #       size: 'sm',
          #       flex: 5
          #     }
          #   ]
          # },
          # {
          #   type: 'box',
          #   layout: 'baseline',
          #   spacing: 'sm',
          #   contents: [
          #     {
          #       type: 'text',
          #       text: 'ナンバー',
          #       size: 'sm',
          #       color: '#aaaaaa',
          #       flex: 2
          #     },
          #     {
          #       type: 'text',
          #       text: form.car_number,
          #       wrap: true,
          #       color: '#666666',
          #       size: 'sm',
          #       flex: 5
          #     }
          #   ]
          # },
          # {
          #   type: 'box',
          #   layout: 'baseline',
          #   spacing: 'sm',
          #   contents: [
          #     {
          #       type: 'text',
          #       text: '盗難時刻',
          #       size: 'sm',
          #       color: '#aaaaaa',
          #       flex: 2
          #     },
          #     {
          #       type: 'text',
          #       text: form.stole_time,
          #       wrap: true,
          #       color: '#666666',
          #       size: 'sm',
          #       flex: 5
          #     }
          #   ]
          # },
          # {
          #   type: 'box',
          #   layout: 'baseline',
          #   spacing: 'sm',
          #   contents: [
          #     {
          #       type: 'text',
          #       text: '盗難場所',
          #       size: 'sm',
          #       color: '#aaaaaa',
          #       flex: 2
          #     },
          #     {
          #       type: 'text',
          #       text: form.stole_location,
          #       wrap: true,
          #       color: '#666666',
          #       size: 'sm',
          #       flex: 5
          #     }
          #   ]
          # },
          # {
          #   type: 'box',
          #   layout: 'baseline',
          #   spacing: 'sm',
          #   contents: [
          #     {
          #       type: 'text',
          #       text: '連絡先',
          #       size: 'sm',
          #       color: '#aaaaaa',
          #       flex: 2
          #     },
          #     {
          #       type: 'text',
          #       text: form.contact,
          #       wrap: true,
          #       color: '#666666',
          #       size: 'sm',
          #       flex: 5
          #     }
          #   ]
          # }
          # ]
        },
        {
          type: 'separator'
        }
      ]
    }
  end

  def set_footer(form)
    {
      type: 'box',
      layout: 'vertical',
      spacing: 'sm',
      contents: [
        {
          type: 'button',
          style: 'link',
          height: 'sm',
          action: {
            type: 'uri',
            label: '盗難情報詳細ページ',
            uri: "https://car-theft-info.herokuapp.com/posts/#{form.post.id}"
          }
        },
        {
          type: 'spacer',
          size: 'sm'
        }
      ],
      flex: 0
    }
  end
end
