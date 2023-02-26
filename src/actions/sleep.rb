
class SleepAction < BaseAction
    def initialize(pause)
        @target_time = Time.now.to_f + pause
    end


    def is_blocking?(ctx)
        if Time.now.to_f > @target_time then
            return false
        else
            return true
        end
    end

    def exec(ctx)
    end

end

