

class Object 

    def require_from(dir)
       
        puts "> got dir; #{dir}, f:#{ File.dirname(__FILE__)}"
        Dir.glob(dir)
            .filter do _1.end_with?('.rb') end
            .map do 
                puts _1 
                require _1 
            end
    end

end

token = ENV['TG_TOKEN']

raise 'env variable TG_TOKEN required' unless token 
raise 'env variable TG_TOKEN required' if token.empty?

require_from("./game/*")

require_from("./base/*")
require_from("./model/*")
require_from("./states/*")
require_from("./core/*")
require_from("./lib/*")
require_relative './config'

pp Config

require_relative './ctx_provider'
require_relative './app'

bot = Bot.new(token)
pipe = EventPipe.new 
provider = ContextProvider.new(bot)

bot.connect

Application.new(bot, pipe, provider)
    .tap do |app|
        app.setup_handlers()
      #  app.run_ctxes()
        app.run()
    end

