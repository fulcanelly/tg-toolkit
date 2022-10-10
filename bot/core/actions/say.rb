
# group_kb_by_size :: [Text] -> [[Text]]
def group_kb_by_size(kb)
    return kb if kb.empty?

    avg = kb.map(&:size)
            .then do |table|
                (table.min + table.max) / 2.0 
            end 
    

    kb.reduce([[]]) do |res, str|
        res.tap do 
            _1.last << str 

            row_size = _1.last
                .map(&:size).sum
            _1 << [] if row_size >= avg 
        end
    end

end

def str_arr_to_kb(arr)
    unless arr.empty? then
        {
            keyboard: group_kb_by_size(arr),
            resize_keyboard: true
#            input_field_placeholder: ""
        }
    else 
        {
            remove_keyboard: true
        }
    end

end

class TgSayAction < BaseAction

    def initialize(text, kb: nil)
        @text = text
        @kb = kb
    end

    def exec(ctx)   
        ctx.extra.bot.send_message({
            text: @text, 
            chat_id: ctx.extra.user_id,
            reply_markup: if @kb then 
                    str_arr_to_kb(@kb)
                else {}
                end
        })
    end

end