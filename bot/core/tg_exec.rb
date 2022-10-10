require_from(__dir__ + '/actions/*')





class ValidatedTextExpectorAction < BaseAction 

    ## validator :: MessageText -> Bool
    def initialize(validator)

    end

    # is_blocking? :: IORef Ctx -> IO Bool
    def is_blocking?(ctx)

    end

    # exec :: IORef Ctx -> IO ()
    def exec(ctx)

    end

end


class TGExecutor < BaseActionExecutor

    def expect_text
        Fiber.yield TgTextExpectorAction.new 
    end

    def say(text, **data)
        Fiber.yield TgSayAction.new(text, **data)
    end

    def switch_state(state)
        Fiber.yield(TgSwitchStateAction.new(state))
    end

    def sleep(time) 
       Fiber.yield(SleepAction.new(time)) 
    end

    def expect_enum(options, on_wrong_message)
        Fiber.yield ExpectEnumAction.new(options, on_wrong_message)
    end


end