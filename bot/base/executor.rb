
#is used to change actions back-end
#(is an example of bridge pattern)


class RandAction < BaseAction
    
    def exec(ctx)
        rand
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
    
end
