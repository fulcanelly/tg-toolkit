
#is used to change actions back-end
#(is an example of bridge pattern)


class RandAction < BaseAction

    def exec(ctx)
        rand
    end

end

class EscapeAction < BaseAction
    attr_accessor :block

    def initialize(block)
        self.block = block
    end

    def exec(ctx)
        self.block.call(ctx)
    end
end

class BaseActionExecutor

    def expect_text
        throw 'not implemented'
    end

    def say(text)
        throw 'not implemented'
    end

    def random
        Fiber.yield RandAction.new
    end

    def escape(&block)
        Fiber.yield EscapeAction.new(block)
    end

end
