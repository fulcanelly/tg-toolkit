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
            }),
            name:
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

class RestorerExecutor < Struct.new(:data)
   
    def method_missing(name, *args, **wargs, &block)
        entry = Marshal.load(data.shift.data)
        Fiber.yield(:fail) if entry.keys.first != name
        Fiber.yield(:done) if data.empty?
        return entry.values.first
    end

end

class StateRestorer < Struct.new(:state, :user_id)

    def load_actions 
        User.find_by(user_id:)
            .actions
            .order(id: :asc)
            .to_a
    end

    def default_fiber
        Fiber.new do 
            self.state.run 
        end
    end

    def __destroy_actions() 
        User.find_by(user_id:)
            .actions
            .destroy_all()
    end

    def __try(fib) 
        begin 
            fib.resume
        rescue => e     
            __destroy_actions()
            #TODO add 4fallback state
            default_fiber
        end
    end

    def try_restore 
        unless User.find_by(user_id:).actions then 
            return default_fiber()
        end


        actions = load_actions()
        return default_fiber if actions.empty?

        self.state.executor = RestorerExecutor.new(actions) 

        result = default_fiber
        case __try(result)
        when :done 
            result
        else    
            __destroy_actions()
            default_fiber
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
