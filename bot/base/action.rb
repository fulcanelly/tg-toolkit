class BaseAction
    
    #only for blocking actions
    #if can -> exec() else wait next cycle
    def can_be_executed?(ctx) 
        throw 'todo'    
    end
    

        
    #
    def exec(ctx)
        throw "can't run base action"
    end


    def is_blocking?(ctx)
        false
    end
end
