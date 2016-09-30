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
        puts array_mess[0]

        if(array_mess[0]=="name")
          client_name = array_mess[1]
          puts client_name
          $dict_users[client_name] = client_sock
          client = Client.where(:login=>client_name).first()
          messages = Messages.where(:receiver_id=>client)
          #select * from messages join clients on messages.receiver_id=client.id where
          # login=client_name

          messages.find_each do |message|
            sender_login = Client.where(:id=>message.sender_id).first()
            mess = message.body
            client_sock.send_data(sender_login.login+":"+mess)
          end
        elsif(array_mess[0]=="list")
          output = "list:"
          users = $dict_users.keys
          users.each{ |user| output = output + user + "\n" }
          client_sock.send_data(output)
        elsif(array_mess[0]=="broadcast")
          sockets = $dict_users.values
          message = "broadcast:" + array_mess[1] + "\n"
          sockets.each{ |socket| socket.send_data(message) }
        elsif(array_mess[0]=="disconnect")
          name = $dict_users.index(client_sock)
          $dict_users.delete(name)
        else
          receiver = array_mess[0]
          sender = $dict_users.index(client_sock)
          mess = array_mess[1]
          receiver_sock = $dict_users[receiver]

          if(receiver_sock==nil)
            sender_client = Client.where(:login => sender).first()
            receiver_client = Client.where(:login=>receiver).first()
            m = Messages.new(:body=>mess)
            m.sender = sender_client
            m.receiver = receiver_client
            m.save
          else
            output = sender + ":" + mess
            receiver_sock.send_data(output)
          end
        end
      end
    end
  end
end
