#TODO implement action recording and action-based state restoring 

class ValidatedTextExpectorAction < BaseAction 

    attr_accessor :validator

    ## validator :: MessageText -> Bool
    def initialize(validator)
        self.validator = validator
    end

    # is_blocking? :: IORef Ctx -> IO Bool
    def is_blocking?(ctx)

    end

    # exec :: IORef Ctx -> IO ()
    def exec(ctx)

    end

end


