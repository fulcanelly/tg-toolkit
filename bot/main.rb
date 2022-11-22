require 'active_record'
require 'ostruct'
require 'net/http'
require 'json'
require 'cgi'
require 'open-uri'
require 'recursive-open-struct'
require 'logger'
require 'colored'

require_relative './autoload'

Autoloader.new.load

token = ENV['TG_TOKEN']

raise 'env variable TG_TOKEN required' unless token 
raise 'env variable TG_TOKEN required' if token.empty?

pp Config


HotReloader.new(list_all_rb_files()).tap do |reloader|
    reloader.init
    reloader.entry_point do 

        bot = Bot.new(token)
        pipe = EventPipe.new 
        provider = ContextProvider.new(bot)

        bot.connect

        Application.new(bot, pipe, provider)
            .tap do |app|
                app.setup_handlers()
            #   app.run_ctxes()
                app.run()
            end
    end
    reloader.start
end