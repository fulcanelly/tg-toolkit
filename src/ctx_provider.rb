
## TODO scheduler
## TODO  what it does
# it's needed for Application class, 
# since each user have own context
class ContextProvider 

    attr_accessor :bot, :global_ctx, :context_by_id, :start_state
    
    def initialize(bot, start_state, global: {})
        self.start_state = start_state
        self.bot = bot
        self.context_by_id = {}
        self.global_ctx = OpenStruct.new({
            context_provider: self,
            **global
        }) 
    end

    # get list of all active contextes
    def get_all_ctx() 
        self.context_by_id.values
    end

    # get's default executor
    def default_exec 
        @_executor ||= TGExecutor.new 
    end

    def _get_state_for(user_id)
        unless Config.restore_state then 
            return self.start_state.new
        end

        state = User.find_by(user_id:).try do
                _1.state 
            end

        return self.start_state.new unless state 
        
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

    # creates fiber for State::run or restores it
    def obtain_fiber(state, user_id)
        if Config.restore_actions then 
            StateRestorer.new(state, user_id).try_restore
        else 
            Fiber.new do 
                state.run
            end
        end
    end

    # creates ctx by user id
    def create_ctx(user_id) 
        #setting up state 
        state = _get_state_for(user_id)  

        #setting up fiber
        fiber = obtain_fiber(state, user_id)

        #setting up context 
        ctx = Context.new(fiber, state) 
        
        #setting up executor 
        state.executor = RecordedExecutor.new(
            default_exec(), ctx)

        ctx.global = self.global_ctx
        ctx.extra = OpenStruct.new({
            bot: self.bot, 
            user_id: user_id, 
            mailbox: [],
            provider: self
        })
        
        return ctx  
    end


    def find_by_user_id(user_id) 
        ctx = self.context_by_id[user_id] || create_ctx(user_id)
        
        self.context_by_id[user_id] = ctx
    end 


end


