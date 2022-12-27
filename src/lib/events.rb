

class EventPipe 
    
    def initialize
        @listeners = {}
        @hook = proc do end
    end

    def set_hook(&block)
        @hook = block 
    end

    def method_missing(name, *args, **nargs, &block)
        name = name.to_s

        if name.start_with? "on_"
            @listeners[name.split("on_").last.to_sym] = block
        else 
            super(name.to_sym, *args, **nargs, &block)
        end

    end

    def emit(event, *data)
        respolver = @listeners[event]

        if respolver then 
            respolver.(*data)
        else 
            @hook.call(event, data)
            logger.warn "Got unsubsribed event: #{event.to_s.red}"
        end

    end

end

