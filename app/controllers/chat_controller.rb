class ChatController < ApplicationController
  include Tubesock::Hijack

  def chat
    if(session[:login]==nil)
      redirect_to "/"
    end
    @user_login = session[:login]
  end

  def chat_handler
    hijack do |client_sock|
      client_sock.onmessage do |data|
        array_mess = data.split(":")
        sender = $dict_users.key(client_sock) if $dict_users

        if array_mess.size > 1
          receiver = array_mess[0]
          mess = array_mess[1]
          receiver_sock = $dict_users[receiver]
        end

        if(array_mess[0]=="name")
          client_name = array_mess[1]
          $dict_users[client_name] = client_sock
          client = Client.where(:login=>client_name).first()
          messages = Messages.where(:receiver_id=>client)

          messages.find_each do |message|
            sender_login = Client.where(:id=>message.sender_id).first()
            mess = message.body
            client_sock.send_data(sender_login.login + ": " + mess + "\n")
            message.delete
          end
        elsif(array_mess[0]=="list")
          output = "list:"
          users = $dict_users.keys
          users.each{ |user| output = output + user + "\n" }
          client_sock.send_data(output)
        elsif(array_mess[0]=="disconnect")
          name = $dict_users.key(client_sock)
          $dict_users.delete(name)
        elsif(receiver_sock==nil && mess && receiver)
          sender_client = Client.where(:login => sender).first()
          receiver_client = Client.where(:login=>receiver).first()
          m = Messages.new(:body=>mess)
          m.sender = sender_client
          m.receiver = receiver_client
          m.save
        else
          sockets = $dict_users.values

          if(receiver_sock!=nil && mess && receiver)
            message = sender + ":" + array_mess[1] + "\n"
          else
            message = "broadcast:" + array_mess[0] + "\n"
          end
          sockets.each{ |socket| socket.send_data(message) }
        end
      end
    end
  end
end
