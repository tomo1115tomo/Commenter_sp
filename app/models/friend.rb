class Friend < ApplicationRecord
  after_create_commit { FriendBroadcastJob.perform_later self }
  after_destroy_commit { FriendBroadcastJob.perform_later self}
  after_update_commit { FriendBroadcastJob.perform_later self}
end
