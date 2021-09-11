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

    const room_id = "comments" + String(data['room_id']) + "_" + String(user1) + "_" + String(user2);
    const comments = document.getElementById(room_id);
    comments.insertAdjacentHTML('beforeend', data['comment']);

    var current_user_id = document.getElementById('current_user_variable').value;
    if(current_user_id == data['receiver_id']){

    }

    const msg_area = document.getElementById('msg_box');
    msg_area.scrollTop = msg_area.scrollHeight;
  },

  speak: function() {
    return this.perform('speak', {content: content, senderoid:senderid, sender_id:sender_id, receiver_id:receiver_id, room_id:room_id});
  }
});


window.addEventListener('load', function() {
  const msg_area = document.getElementById('msg_box');
  if(msg_area != null){
    msg_area.scrollTop = msg_area.scrollHeight;
  }
});
