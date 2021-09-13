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
    const news_id = "news_" + String(data['receiver_id']);
    const news_area = document.getElementById(news_id);
    var content = "<div id='" + "recent_msg_" + data['receiver_id'] + "_" + data['sender_id'] + "'>" + data['senderid'] + " からの新着メッセージがあります" + "</div>" + '<br>';
    var previous_msg = document.getElementById("recent_msg_" + data['receiver_id'] + "_" + data['sender_id'])

    if(news_area != null){
      if(previous_msg == null){
        news_area.insertAdjacentHTML('beforeend', content);
      }
      else{
        content = "<div id='" + "recent_msg_" + data['receiver_id'] + "_" + data['sender_id'] + "'>" + data['senderid'] + " からの新着メッセージが複数件あります" + "</div>" + '<br>';
        previous_msg.innerHTML = content;
      }
    }
  },

  speak: function() {
    return this.perform('speak');
  }
});
