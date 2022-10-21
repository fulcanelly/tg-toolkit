
require 'colored'

MAX_RUN = 10


class FiberCtxRunner
    
    attr_accessor :fiber, :last_action, :input

    def initialize(fiber, ctx)
        @fiber = fiber 
        @ctx = ctx
    end

    def first_run()
        @last_action = @fiber.resume(nil)
    end

    def can_run? 
        unless @last_action 
            first_run()    
        end 

        return ! @last_action.is_blocking?(@ctx) 
    end

    def iterate()
        @input = @last_action.exec(@ctx)
        @last_action = @fiber.resume(@input)
    end

    def is_blocking?
        @last_action.is_blocking?(@ctx)
    end
    
    def flat_run()
        loop do 
            puts "MY ID IS #{hash}".red
            iterate()
            break unless @last_action.is_a? BaseAction
            break if is_blocking?
        end 
    end

    def flat_run_limited() 
        MAX_RUN.times do 
            iterate()
            break unless @last_action.is_a? BaseAction
            break if is_blocking?
        end 
    end

    def init_from(runner)
        @last_action = runner.last_action
        @input = runner.input
        @fiber = runner.fiber
    end

end



class Context 
    attr_accessor :state, :extra, :global 

    def initialize(fiber, state)
        @state = state
        @runner = FiberCtxRunner.new(fiber, self)
    end

    def fiber=(fiber)
        @runner.init_from(FiberCtxRunner.new(fiber, self))
    end
    
    def can_run?()
        @runner.can_run?()
    end 

    def flat_run
       @runner.flat_run_limited()
    end

    def run_hook(hook_fiber)
        FiberCtxRunner.new(hook_fiber, self).tap do 
            if _1.can_run? then 
                _1.flat_run()
            end
        end 
        #TODO
    end

end



