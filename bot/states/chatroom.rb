#TODO


class ChatroomMessage 
    
    attr_accessor :sender, :text 

    def initialize(sender, text)
        @sender = sender
        @text = text   
    end

end


class ChatroomObject 
    
    def initialize
        @users = []
    end

    def join_chat(person)
        @users << person
    end

    def _all_expect(list, person)
        list.filter do |ctx|
            ctx.extra.user_id != person.extra.user_id 
        end
    end


    def leave_chat(person)
        @users = _all_expect(@users, person)
    end


    def send_message(person, text)
        _all_expect(@users.lazy, person)
            .each do |ctx|

                fiber = Fiber.new do 
                    ctx.state.on_message(
                        ChatroomMessage.new(person.extra.user_id, text)
                    )
                end

                #TODO: use scheduling for that 
                ctx.run_hook(fiber)

               # ctx.state. 
            end

    end

end

class JoinRoomAction < BaseAction 
    def is_blocking?(ctx)
    end

    def exec(ctx)
        ctx.global.chattroom.join_chat(ctx)
    end
end


class SendChatRoomMessage < BaseAction 
    def initialize(text)
        @text = text
    end

    def is_blocking?(ctx)
        false 
    end

    def exec(ctx)
        ctx.global.chattroom.send_message(ctx, @text)
    end
end



class ChattingState < BaseState 

    def join_chatroom!()
        Fiber.yield JoinRoomAction.new
    end

    def setup_enum!()
        #TODO
    end

    def send_chatroom(text)
        Fiber.yield SendChatRoomMessage.new(text)
    end
    
end


class ChattingXState < ChattingState

    def initialize(state)
        @return_state = state 
    end

    def on_message(msg)
        say "#{msg.sender}> #{msg.text}"
    end


    def on_enum(enum) 
        case enum 
        when "Назад"
            switch_state(@return_state)
        else 
            throw "Should never ever heppen"
        end
    end

    def run()
        join_chatroom!() 
        setup_enum!() 

        loop do 
            send_chatroom(expect_text())
        end
    end


end
