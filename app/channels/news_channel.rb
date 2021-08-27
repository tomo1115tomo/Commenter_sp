class NewsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "news_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
  end
end
