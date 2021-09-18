import consumer from "./consumer"

const appRoom = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    var user1 = Number(data['sender_id']);
    var user2 = Number(data['receiver_id']);
    if (user1 > user2){
      var tmp = user1;
      user1 = user2;
      user2 = tmp;
    }

    if(location.pathname == '/users'){
      var recent1_msg_id = "recent1_" + String(data['receiver_id']) + "_" + String(data['sender_id']);
      var recent1_msg_area = document.getElementById(recent1_msg_id);
      var recent2_msg_id = "recent2_" + String(data['receiver_id']) + "_" + String(data['sender_id']);
      var recent2_msg_area = document.getElementById(recent2_msg_id);
      var follow_list_id = "follow_list_" + String(data['receiver_id'])
      var follow_list_area = document.getElementById(follow_list_id)

      if(Number(data['expression']) == 0){
        var msg_content = '<td align="right" style="color:white">' + data['created_at'] + '</td>' + '<td colspan="4" style="color:white">' + data['content'] + '</td>';
      }
      else{
        var title_length = String(data['title']).length;
        var msg_content = '<td align="right" style="color:white">' + data['created_at'] + '</td>' + '<td colspan="4" style="color:white">' + "件名" + "【" + data['title'] + "】" + String(data['long_content']).substr(0, 40 - title_length) + "...." + '</td>';
      }
      recent2_msg_area.innerHTML = msg_content;

      recent1_msg_area.remove();
      recent2_msg_area.remove();
      follow_list_area.prepend(recent2_msg_area);
      follow_list_area.prepend(recent1_msg_area);
    }
    else{
      const room_id = "comments" + String(data['room_id']) + "_" + String(user1) + "_" + String(user2);
      const comments = document.getElementById(room_id);
      const msg_area = document.getElementById('msg_box');

      comments.insertAdjacentHTML('beforeend', data['comment']);
      msg_area.scrollTop = msg_area.scrollHeight;
    }
  },

  speak: function() {
    return this.perform('speak', {content: content, title: title, long_content:long_content, senderoid:senderid, sender_id:sender_id, receiver_id:receiver_id, room_id:room_id, emotion:emotion, expression:expression});
  }
});


window.addEventListener('load', function() {
  const msg_area = document.getElementById('msg_box');
  if(msg_area != null){
    msg_area.scrollTop = msg_area.scrollHeight;
  }
});
