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
      var recent_msg_id = "recent_" + String(data['receiver_id']) + "_" + String(data['sender_id']);
      var recent_msg_area = document.getElementById(recent_msg_id);

      var msg_content = '<td align="right" style="color:white">' + data['created_at'] + '</td>' + '<td colspan="3" style="color:white">' + data['content'] + '</td>';
      recent_msg_area.innerHTML = msg_content;
    }


    const room_id = "comments" + String(data['room_id']) + "_" + String(user1) + "_" + String(user2);
    const comments = document.getElementById(room_id);

    if(comments != null){
      comments.insertAdjacentHTML('beforeend', data['comment']);
    }

    var current_user_id = document.getElementById('current_user_variable').value;
    if(current_user_id == data['receiver_id']){
      window.location.reload(true);
    }
    else if(current_user_id == data['sender_id']){
      
    }

    const msg_area = document.getElementById('msg_box');
    if(msg_area != null){
      msg_area.scrollTop = msg_area.scrollHeight;
    }

  },

  speak: function() {
    return this.perform('speak', {content: content, title: title, senderoid:senderid, sender_id:sender_id, receiver_id:receiver_id, room_id:room_id, emotion:emotion, expression:expression});
  }
});


window.addEventListener('load', function() {
  const msg_area = document.getElementById('msg_box');
  if(msg_area != null){
    msg_area.scrollTop = msg_area.scrollHeight;
  }
});
