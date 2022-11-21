
class Application 

    attr_accessor :bot, :pipe, :provider

    def initialize(bot, pipe, provider)
        @bot = bot 
        @pipe = pipe
        @provider = provider
    end

    def check_token()
        unless bot.get_me([]).ok then  
            throw 'wrong bot token'
        end
    end

    def run()
        loop do 
            # pp provider
            bot.fetch(pipe)
            run_ctxes()
        end
    end

    def _update_user_from(from)
        user_id = from.id 
        name = from.first_name

        user = User.find_by(user_id:) 

        unless user then 
            return User.new(user_id:, name: name).save
        end

        if name != user.name
            user.name = name 
            user.save
            return 
        end        
    end

    def _on_message(msg)
        user_id = msg.from.id
        
        provider.find_by_user_id(user_id).tap do |ctx|
            ctx.extra.mailbox << msg.text 
        end
        
        #TODO
     #   optional_pipe.emit()
        
        _update_user_from(msg.from)    
    end

    def setup_handlers() 

        pipe.on_message do |msg|
            _on_message(msg)
        end
        
        pipe.on_callback_query do 
            #TODO
        end

    end


    def run_ctxes()
        provider.get_all_ctx().lazy()
            .filter() do 
                _1.can_run?
            end.map() do 
                _1.flat_run()
            end
            .force()
    end

end
