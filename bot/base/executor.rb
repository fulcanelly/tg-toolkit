
#is used to change actions back-end
#(is an example of bridge pattern)

class BaseActionExecutor 

    def expect_text
        throw 'not implemented'
    end

    def say(text)
        throw 'not implemented'
    end

end