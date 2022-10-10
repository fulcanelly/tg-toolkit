
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


#state reperesents an certain state of user with server interaction
class BaseState 
    
    attr_accessor :executor
    
    #print message to user
    def say(text, **data)
        executor.say(text, **data)
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


    # is used to run when state started 
    #can't end with nil (undefined behaviour)
    def run 
        throw 'base state'
    end
end