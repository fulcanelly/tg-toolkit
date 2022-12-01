
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
        unless Config.restore_state then 
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

    def obtain_fiber(state, user_id)
        if Config.restore_actions then 
            StateRestorer.new(state, user_id).try_restore
        else 
            Fiber.new do 
                state.run
            end
        end
    end

    def create_ctx(user_id) 
        #setting up state 
        state = _get_state_for(user_id) #StartingState.new 

        #setting up fiber
        fiber = obtain_fiber(state, user_id)

        #setting up context 
        ctx = Context.new(fiber, state) 
        
        #setting up executor 
        state.executor = RecordedExecutor.new(
            default_exec(), ctx)

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


