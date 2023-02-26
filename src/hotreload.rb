require 'colored'


def list_all_files(folder = ".")
    result = []
    Dir.entries(folder)
        .filter() do |path|
            (path != '.') and (path != '..')
        end
        .each do |path|
        File
        full_path = folder + "/" + path
        if File.directory?(full_path) then
            result.push(
                *list_all_files(full_path)
            )
        else
            result << full_path
        end
    end
    result
end

def list_all_rb_files
    list_all_files.filter do |f|
        f.end_with? ".rb"
    end

end

def list_all_loaded_rb_files
    #TODO
end



class HotReloader

    attr_accessor :files_to_watch, :last_update_by_filenames, :start_block

    def initialize(_files_to_watch)
        if _files_to_watch.is_a? Array then
            self.files_to_watch = _files_to_watch
        else
            define_singleton_method(:files_to_watch) do
                _files_to_watch.call()
            end
        end
        @last_update_by_filenames = {}
    end

    def init
        self.files_to_watch.each do |path|
            @last_update_by_filenames[path] = File.mtime(path)
        end
    end

    def entry_point(&block)
        self.start_block = block
    end


    def is_already_running?
        is_runing = Thread.list.find do |thr|
            thr.name == "Hot realoader"
        end

        logger.info "is runing : #{is_runing}"
        is_runing
    end

    def check_files()


        logger.info "checking files and threads".green

        main_thread = Thread.list.find do |thr|
            thr.name == "main thread"
        end

        unless main_thread then
            start_main_thread
        end

        changed_files = []
        self.files_to_watch.each do |path|

            probably_new_time = File.mtime(path)

            if probably_new_time != last_update_by_filenames[path]
                logger.info 'got change'.green
                @last_update_by_filenames[path] = probably_new_time
                changed_files << path

            end


        end

        unless changed_files.empty? then
            logger.info "applying change".green
            apply_update(changed_files)
        end


    end

    def apply_update(changed_files)
        logger.info "loading changes".yellow
        changed_files.each do |file|
            begin
                load(file)
            rescue => e
                puts e
            end

        end
    end

    def iterate
        check_files()
        sleep(Config.hotreload_check_time)
    end

    def start_main_thread
        logger.info "Starting main thread".red
        Thread.new do
            Thread.current.name = "main thread"
            self.start_block.call()
        end
    end

    def start_reloader_thread
        Thread.new do
            Thread.current.name = "Hot realoader"

            loop do
                iterate()
            end

        end

    end

    def start
        return if is_already_running?()
        start_main_thread()
        start_reloader_thread().join
    end

end
