class Messages < ActiveRecord::Base
  belongs_to :sender, :class_name => 'Client', foreign_key: 'sender_id'
  belongs_to :receiver, :class_name => 'Client', foreign_key: 'receiver_id'
  # has_and_belongs_to_many :sender,
  #                         class_name: 'Client',columns: 'sender_id'
  # has_and_belongs_to_many :receiver,
  #                         class_name: 'Client',columns: 'receiver_id'
end
