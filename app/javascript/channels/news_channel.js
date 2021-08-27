import consumer from "./consumer"

consumer.subscriptions.create("NewsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const news_id = "news_" + String(data['receiverid']);
    const news_area = document.getElementById(news_id);
    news_area.insertAdjacentHTML('beforeend', data['senderid'] + " からの新着メッセージがあります" + '<br>');
  },

  speak: function() {
    return this.perform('speak');
  }
});
