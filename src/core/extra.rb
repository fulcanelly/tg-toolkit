
class Extra

    def obtain
        throw 'todo'
    end

end

class KeyboardExtra < Extra
    attr_accessor :remove_keyboard, :keyboard

    def initialize(keyboard, remove)
        @keyboard = keyboard
        @remove_keyboard = remove
    end

    def remove()
        self.remove = true
        return self
    end

    def obtain
        return {
            keyboard:,
            remove_keyboard:
        }
    end

end

class << KeyboardExtra

    def just_remove()
        return Keyboard.new([], true)
    end

    def create(text2d)
        return Keyboard.new(text2d, false)
    end

    def auto_aligned(array)
        return Keyboard.new(group_kb_by_size(array), false)
    end

end


#todo: move to toolkit
class InlineKeyboardHelper
    def method_missing(name, *args, **vargs)
        data = {
            name:,
            args:,
            vargs:
        }

        dump = Marshal.dump(data)
        found = InlineKeyboard.find_by(dump:)

        if found then found else InlineKeyboard.create(dump:) end.id
    end
end

class InlineKeyboardExtra < Extra

    attr_accessor :inline_keyboard

    def initialize(kb)
        @inline_keyboard = kb
    end

    def add_row(*row)
        inline_keyboard << row
        return self
    end


    def ikbhelper
        #TODO
        InlineKeyboardHelper.new
    end


    def obtain
        return {
            inline_keyboard:
        }
    end

end

class << InlineKeyboardExtra
    def create
        InlineKeyboardExtra.new([])
    end

end


def ibutton(text, callback_data)
    return {
        text:, callback_data:
    }
end

