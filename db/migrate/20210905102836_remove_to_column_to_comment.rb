class RemoveToColumnToComment < ActiveRecord::Migration[6.1]
  def chnage
    remove_colmun :comments, :senderid
    remove_colmun :comments, :receiverid
  end
end
