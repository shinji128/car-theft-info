class PostsController < ApplicationController
  def new
    @form = PostForm.new
  end

  def create
    @form = PostForm.new(post_params)
    if @form.save
      # msg = { type: 'text', text: @form.text }
      binding.pry
      message = { type: 'flex', altText: '盗難車両', contents: set_bubble(@form) }
      client.broadcast(message)
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post_form).permit(:car_name, :car_model, :car_number, :stole_time,
                                      :stole_location, :contact, { images: [] })
          .merge(user_id: current_user.id)
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def set_bubble(form)
    {
      type: 'bubble',
      hero: set_hero(form),
      body: set_body(form),
      footer: set_footer
    }
  end

  def set_hero(form)
    {
      type: 'image',
      url: form.post.images[0].image.url,
      size: 'full',
      aspectRatio: '20:13',
      action: {
        type: 'uri',
        uri: 'https://www.google.com/?hl=ja'
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
          contents: [
            {
              type: 'box',
              layout: 'baseline',
              spacing: 'sm',
              contents: [
                {
                  type: 'text',
                  text: '車名',
                  size: 'sm',
                  color: '#aaaaaa',
                  flex: 2
                },
                {
                  type: 'text',
                  text: form.car_name,
                  wrap: true,
                  color: '#666666',
                  size: 'sm',
                  flex: 5
                }
              ]
            },
            {
              type: 'box',
              layout: 'baseline',
              spacing: 'sm',
              contents: [
                {
                  type: 'text',
                  text: '型式',
                  size: 'sm',
                  color: '#aaaaaa',
                  flex: 2
                },
                {
                  type: 'text',
                  text: form.car_model,
                  wrap: true,
                  color: '#666666',
                  size: 'sm',
                  flex: 5
                }
              ]
            },
            {
              type: 'box',
              layout: 'baseline',
              spacing: 'sm',
              contents: [
                {
                  type: 'text',
                  text: 'ナンバー',
                  size: 'sm',
                  color: '#aaaaaa',
                  flex: 2
                },
                {
                  type: 'text',
                  text: form.car_number,
                  wrap: true,
                  color: '#666666',
                  size: 'sm',
                  flex: 5
                }
              ]
            },
            {
              type: 'box',
              layout: 'baseline',
              spacing: 'sm',
              contents: [
                {
                  type: 'text',
                  text: '盗難時刻',
                  size: 'sm',
                  color: '#aaaaaa',
                  flex: 2
                },
                {
                  type: 'text',
                  text: form.stole_time,
                  wrap: true,
                  color: '#666666',
                  size: 'sm',
                  flex: 5
                }
              ]
            },
            {
              type: 'box',
              layout: 'baseline',
              spacing: 'sm',
              contents: [
                {
                  type: 'text',
                  text: '盗難場所',
                  size: 'sm',
                  color: '#aaaaaa',
                  flex: 2
                },
                {
                  type: 'text',
                  text: form.stole_location,
                  wrap: true,
                  color: '#666666',
                  size: 'sm',
                  flex: 5
                }
              ]
            },
            {
              type: 'box',
              layout: 'baseline',
              spacing: 'sm',
              contents: [
                {
                  type: 'text',
                  text: '連絡先',
                  size: 'sm',
                  color: '#aaaaaa',
                  flex: 2
                },
                {
                  type: 'text',
                  text: form.contact,
                  wrap: true,
                  color: '#666666',
                  size: 'sm',
                  flex: 5
                }
              ]
            }
          ]
        },
        {
          type: 'separator'
        }
      ]
    }
  end

  def set_footer
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
            label: 'WEB',
            uri: 'https://www.google.com/?hl=ja'
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
