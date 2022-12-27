
class EditMessageText < BaseAction

    def initialize(message_id, text, reply_markup)
        @message_id = message_id
        @text = text
        @reply_markup = reply_markup
    end

    def exec(ctx)
        ctx.extra.bot.edit_message_text({
            text: @text, 
            chat_id: ctx.extra.user_id,
            message_id: @message_id,
            reply_markup: @reply_markup
        })
    end

end
