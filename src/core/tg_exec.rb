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

    def suspend(time)
       Fiber.yield(SleepAction.new(time))
    end

    def expect_enum(options, on_wrong_message)
        Fiber.yield ExpectEnumAction.new(options, on_wrong_message)
    end

    def myself
        Fiber.yield GetMeAction.new
    end

    def edit_text(msg, text, reply_markup)
        Fiber.yield EditMessageText.new(msg, text, reply_markup)
    end

end
