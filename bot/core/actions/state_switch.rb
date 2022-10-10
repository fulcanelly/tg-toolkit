

class TgSwitchStateAction < BaseAction 

    def initialize(target_state) 
        @target_state = target_state
    end

    def _store_state(user_id)
    #TODO(i mean move State actions to state manager and then move it to ctx)

        State.where(user_id:).delete_all()
        State.new(
            user_id:, 
            state_dump: Marshal.dump(
                @target_state
            ),
        ).save() 
    end

    def exec(ctx)
        _store_state(ctx.extra.user_id)

        @target_state.executor = ctx.state.executor


        ctx.state = @target_state
        ctx.fiber = Fiber.new do 
            ctx.state.run
        end
    end

end