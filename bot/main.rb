

class Object 

    def require_from(dir)
       
        puts "> got dir; #{dir}, f:#{ File.dirname(__FILE__)}"
        Dir.glob(dir)
            .filter do _1.end_with?('.rb') end
            .map do 
                puts _1 
                require _1 
            end
    end

end

token = ENV['TG_TOKEN']

raise 'env variable TG_TOKEN required' unless token 
raise 'env variable TG_TOKEN required' if token.empty?

require_from("./game/*")

require_from("./base/*")
require_from("./model/*")
require_from("./states/*")
require_from("./core/*")
require_from("./lib/*")
require_relative './config'

pp Config

## TODO scheduler
class ContextProvider 


    def get_all_ctx() 
        return @context_by_id.values
    end

    def initialize(bot)
        @bot = bot
        @context_by_id = {}
        @global_ctx = OpenStruct.new({
            context_provider: self,
            chattroom: ChatroomObject.new 
        }) 
    end

    def default_exec 
        @_executor ||= TGExecutor.new 
    end

    def _get_state_for(user_id)
        unless Config.resotre_state then 
            return StartingState.new
        end

        state = User.find_by(user_id:).try do
                _1.state 
            end

        return StartingState.new unless state 
        
        return Marshal.load(
            state.state_dump
        )
    end

    def _update_state_for(user_id, target_state) 
        user = User.find_by(user_id:)
        
        state_dump = Marshal.dump(target_state)

        unless user.state then 
            user.state = State.new( 
                state_dump:
            )
        else 
            user.state.state_dump = state_dump
        end
        user.save
    end

    def create_ctx(user_id) 
        #setting up state 
        state = _get_state_for(user_id) #StartingState.new 
        state.executor = default_exec()

        #setting up fiber
        fiber = Fiber.new do 
            state.run
        end

        #setting up context 
        ctx = Context.new(fiber, state) 
        ctx.global = @global_ctx
        ctx.extra = OpenStruct.new({
            bot: @bot, 
            user_id: user_id, 
            mailbox: [],
            provider: self
        })
        
        return ctx  
    end


    def find_by_user_id(user_id) 
        ctx = @context_by_id[user_id] || create_ctx(user_id)
        
        @context_by_id[user_id] = ctx
    end 


end






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

bot = Bot.new(token)
pipe = EventPipe.new 
provider = ContextProvider.new(bot)

bot.connect

Application.new(bot, pipe, provider)
    .tap do |app|
        app.setup_handlers()
      #  app.run_ctxes()
        app.run()
    end

