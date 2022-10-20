



MAX_RUN = 10


class Context 
    attr_accessor :fiber, :state, :extra, :global 

    def initialize(fiber, state)
        @fiber = fiber
        @state = state
        @last_action = nil
    end

    def first_run 
        @last_action = @fiber.resume(nil)
    end

    def can_run? 
        unless @last_action 
            first_run()    
        end 

        return ! @last_action.is_blocking?(self) 
    end
    
    def flat_run
        MAX_RUN.times do 
            @input = @last_action.exec(self)
            @last_action = @fiber.resume(@input)
            break if @last_action.is_blocking?(self)
        end

    end


end



