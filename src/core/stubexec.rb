
class StubSwitchStateAction < BaseAction
    def initialize(target_state)
        @target_state = target_state
    end

    def exec(ctx)
        @target_state.executor = ctx.state.executor

        ctx.state = @target_state
        ctx.fiber = Fiber.new do
            ctx.state.run
        end
    end

end

class StubTextEpectorAction < BaseAction

    def exec(ctx)
        gets()
        #cxt.events.stuff.then do
        #end

    end

    def is_blocking?
        true
    end

end

class StubSayAction < BaseAction

    def initialize(text)
        @text = text
    end

    def exec(ctx)
        puts @text

    end

end

class StubExecutor < BaseActionExecutor

    def self::instance
        @_self||= self.new
    end

    def expect_text
        Fiber.yield(StubTextEpectorAction.new)
    end

    def switch_state(state)
        Fiber.yield(StubSwitchStateAction.new(state))
    end

    def say(text)
        Fiber.yield(StubSayAction.new(text))
    end

end
