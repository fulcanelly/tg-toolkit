


class TgTextExpectorAction < BaseAction

    def exec(ctx)
        ctx.extra.mailbox.shift 
    end

    def is_blocking?(ctx)
        ctx.extra.mailbox.empty?
    end

end
