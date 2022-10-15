

class TgSwitchStateAction < BaseAction 

    def initialize(target_state) 
        @target_state = target_state
    end

    def exec(ctx)
        ctx.extra.provider._update_state_for(
            ctx.extra.user_id, 
            @target_state
        )

        @target_state.executor = ctx.state.executor

        ctx.state = @target_state
        ctx.fiber = Fiber.new do 
            ctx.state.run
        end
    end

end