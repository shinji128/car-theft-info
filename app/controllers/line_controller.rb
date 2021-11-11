class LineController < ApplicationController
  protect_from_forgery except: [:callback]
  def callback
    msg = { type: 'text', text: 'test' }
    client.broadcast(msg)
    redirect_to root
  end

  private

  def client
    @client ||= Line::Bot::Client.new do { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
  end
end
