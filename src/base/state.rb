
class SuggesterBuilder

    def initialize(state, title)
        @title = title
        @state = state
        @options = {}
    end

    def wrong(wrong)
        @wrong = wrong
        return self
    end

    def option(title, &block)
        @options[title] = block
        return self
    end

    def exec
        buttons = @options.keys

        @state.say @title, kb: buttons
        selected = @state.expect_enum(buttons, @wrong)
        @options[selected].call
    end

end


module StateExtension
end


#TODO: remove executor from here

#state reperesents an certain state of user with server interaction
class BaseState

    include StateExtension

    attr_accessor :executor


    #print message to user
    def say(text, kb: [], **data)
        executor.say(text, **{kb:, **data})
    end

    def capture_text_or_cancel(enter_phrase, cancel_phrase)
        say enter_phrase, kb: [cancel_phrase]
        inp = expect_text
        return if inp == cancel_phrase
        return inp
    end

    #blocks until user enters something
    def expect_text()
        executor.expect_text()
    end

    def expect_validated_text
        throw 'no implementation '
    end

    #switches state
    def switch_state(state)
        executor.switch_state(state)
    end

    def sleep(time)
        executor.sleep(time)
    end

    #called when state get's callback query
    #(i.e. user taps inline kb)
    def on_cb()
    end

    def expect_enum(*args)
        executor.expect_enum(*args)
    end

    def _suggest(tittle, options)
        say tittle, kb: options
        selected = expect_enum(options, "Немає такого варіанту")
    end

    def suggest_it(title)
        SuggesterBuilder.new(self, title)
            .wrong("Немає такого варіанту")
    end


    # used to wrap code that not need to run when state is restoring
    def escape(&block)
        executor.escape(&block)
    end

    #makes code run not always witch some chance
    #it can't be recorded / restored
    def run_sometimes(&block)
        if executor.random > 0.5 then
            block.call
        end
    end

    def random
        executor.random
    end

    # returns database object representing it's user
    def myself
        executor.myself
    end

    # is used to run when state started
    #can't end with nil (undefined behaviour)
    def run
        throw 'base state'
    end

    #edit text
    def edit_text(msg, text, reply_markup)
        executor.edit_text(msg, text, reply_markup)
    end

end
