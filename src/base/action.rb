class BaseAction
    
    def exec(ctx)
        throw "can't run base action"
    end

    #only for blocking actions
    #if false -> exec() else wait next cycle
    def is_blocking?(ctx)
        false
    end
    
end
