

class TgSwitchStateAction < BaseAction 

    def initialize(target_state) 
        @target_state = target_state
    end

    #it's workaround for action recording 
    # since state cannot be seriazlied if it's fields have functions/etc
    def with_nil_executor(&block)         
        executor = @target_state.executor 
        @target_state.executor = nil
        block.call
        @target_state.executor = executor
    end

    def exec(ctx)
        
        with_nil_executor do 
            ctx.extra.provider._update_state_for(
                ctx.extra.user_id, 
                @target_state
            )
        end


        @target_state.executor = ctx.state.executor

        ctx.state = @target_state
        ctx.fiber = Fiber.new do 
            ctx.state.run
        end
    end

end