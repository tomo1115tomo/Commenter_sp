import consumer from "./consumer"

const appRoom = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var user1 = String(data['senderid']);
    var user2 = String(data['receiverid']);
    if (user1 > user2){
      var tmp = user1;
      user1 = user2;
      user2 = tmp;
    }

    const room_id = "comments" + String(data['roomid']) + "_" + user1 + "_" + user2;
    const comments = document.getElementById(room_id);
    comments.insertAdjacentHTML('beforeend', data['comment']);

    const msg_area = document.getElementById('msg_box');
    msg_area.scrollTop = msg_area.scrollHeight;
  },

  speak: function(comment) {
    return this.perform('speak', {content: comment, senderid:sender, receiverid:receiver, roomid:roomid});
  }
});

window.addEventListener('keypress', function(e) {
  if (e.keyCode === 13) {
    appRoom.speak(e.target.value);
    e.target.value = '';
    e.preventDefault();
  }
});
