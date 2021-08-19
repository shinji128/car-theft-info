class PostsController < ApplicationController
  def new
    @form = PostForm.new
  end

  def create
    @form = PostForm.new(post_params)
    if @form.save
      msg = { type: 'text', text: @form.text }
      client.broadcast(msg)
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
end
