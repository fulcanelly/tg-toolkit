#TODO better move to BaseAction


class RecordedExecutor 
    
    attr_accessor :inner_executor, :ctx

    
    def initialize(inner_executor, ctx) 
        self.inner_executor = inner_executor
        self.ctx = ctx
    end

    def actions
        User.find_by(user_id: ctx.extra.user_id).actions
    end

    def save_result(name, result)                    
        actions.create(
            data: Marshal.dump({
                name => result
            })
        )
    end

    def method_missing(name, *args, **wargs, &block)
        actions.destroy_all() if name == :switch_state

        #if inner_executor.method_defined? name then 
        inner_executor.send(name, *args, **wargs, &block).tap do |result|
            save_result(name, result)
        end

    end
   

end

# WARN redo
# since we can serialize state, we need make sure it's executor won't be 
# since it can have reference to functions/fibers/ctx etc
def __clean_state(state)  
    state.clone.tap do 
        _1.executor = nil
    end
end
