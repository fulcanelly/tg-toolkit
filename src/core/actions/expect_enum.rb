
class ExpectEnumAction < BaseAction 

    def initialize(options, when_wrong)
        @options = options
        @when_wrong = when_wrong
    end
    
    def is_blocking?(ctx) 

        if ctx.extra.mailbox.empty? then 
            return true 
        end

        text = ctx.extra.mailbox.shift 
        
        if not @options.include?(text) then 
            TgSayAction.new(
                @when_wrong, kb: @options
            ).exec(ctx)
            return true
        end

        @selected = text
        return false
        
    end

    def exec(ctx)
        return @selected
    end
    
    
end

