

#Net::HTTP.get(uri) # => String


# todo: visitor based update parsing
 
def snake_to_camel(str)
    words = str.split(/_/)
    [words[0], words[1..-1].map(&:capitalize)].join
end

class Bot
    attr_accessor :token

    def initialize(token)
        @token = token
    end


    def make_request(http, link)
        hash = JSON.load(
            http.request(Net::HTTP::Get.new(link)).body
        )
        RecursiveOpenStruct.new(hash, recurse_over_arrays: true)
    end


    def method_missing(name, *args, **wargs)
        #TODO: *args --??? wtf...
        request = full_request(snake_to_camel(name.to_s), *args)
        pp request if Config.log_requests
        res = self.make_request(@http, request)
        return res
    end


    def full_request(method, args)
        args = args.map do |pair|
            name, value = pair
            next name, case value
                in String then value
                else JSON.dump(value)
            end
        end.to_h
        "https://api.telegram.org/bot#{@token}/#{gen_request_str(method, args)}"
    end


    def load_file(file_path)
        logger.debug "loading file #{file_path}"
        OpenURI.open_uri("https://api.telegram.org/file/bot#{@token}/#{file_path}")
            .tap do
                logger.debug "loaded file #{_1.inspect.cyan}"

            end
    end


    def on_message(&block)
        @on_message = block
    end

    def on_callback_query(&block)
        @on_callback_query = block
    end

    def connect
        uri = URI"https://api.telegram.org/"
        @http = Net::HTTP.start(uri.host, uri.port, :use_ssl => true)
       # @bound_mapped_bot = HTTPBoundBot.new(mapper, @http)

    end

    def fetch(pipe)
        logger.info "fetching events from tg"

        @offset ||= 0

        result = self.get_updates({
            offset: @offset,
            timeout: 0
        })

        n_offset = result["result"]
            .map do
                _1["update_id"]
            end
            .max

        @offset = unless n_offset then @offset else n_offset + 1 end

        result["result"].each do |upd|

            pipe.emit(*extract_event(upd))

        end

    end

    private

    def extract_event(update)
        = update.to_h()
            .filter() do |key, value| key != :update_id end
            .entries()
            .map do |key, value|
                [key, RecursiveOpenStruct.new(value, recurse_over_arrays: true)]
            end
            .first()

    def gen_request_str(method, args)
        method + "?" +
        args.map do |name, val|
            name.to_s + "=" + CGI.escape((val.to_s))
         end.join("&")
    end



end








