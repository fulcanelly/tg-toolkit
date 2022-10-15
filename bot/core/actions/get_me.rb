class GetMeAction < BaseAction 
    def exec(ctx)
        User.find_by(user_id: ctx.extra.user_id)
    end
end
