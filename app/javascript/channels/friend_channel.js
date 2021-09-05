import consumer from "./consumer"

const appFriend = consumer.subscriptions.create("FriendChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const current_user_id = document.getElementById('current_user_variable').value;
    if(data['user_id'] == current_user_id || data['friend_id'] == current_user_id){
      window.location.reload(true);
    }
  },

  speak: function(userid, friendid, i) {
    /*if(i == 1){
      return this.perform('speak', {userid:userid, friendid:friendid, request:true, allow:false, i:1} );
    }
    else if(i == 0){
      return this.perform('speak', {userid:userid, friendid:friendid, i:0});
    }
    else if(i == 2){
      return this.perform('speak', {userid:userid, friendid:friendid, request:true, allow:true, i:2});
    }
    else if(i == 3){
      return this.perform('speak', {userid:userid, friendid:friendid, i:3});
    }*/
  },
});

/*window.addEventListener('DOMContentLoaded', function(){
  var time = new Date()
  console.log('now_' + time.getMinutes() + ":" + time.getSeconds());
  var buttons = document.querySelectorAll('button[name="friend"]');
  var current_user = document.getElementById('current_user_variable').value;

  for (let i = 0; i < buttons.length; i++) {
    buttons[i].addEventListener('click', function(){
      var id_c = current_user + "_friend_c_" + String(i);
      var id_d = current_user + "_friend_d_" + String(i);
      var content_c = document.getElementById(id_c);
      var content_d = document.getElementById(id_d);

      if(content_c == null){
        //appFriend.speak(current_user, content_d.value, 0);
      }
      else if(content_d == null){
        //appFriend.speak(current_user, content_c.value, 1);
      }
      else{
        window.location.reload(true);
      }

    });
  };

  var friend_edit = document.getElementById('friend_edit');
  if(friend_edit != null){
    friend_edit.addEventListener('click', function() {
      appFriend.speak(current_user, friend_edit.value, 2);
    })
  }

  var friend_destroy = document.getElementById('friend_destroy');
  if(friend_destroy != null){
    friend_destroy.addEventListener('click', function() {
      appFriend.speak(current_user, friend_destroy.value, 3);
    })
  }
}, false);
*/
