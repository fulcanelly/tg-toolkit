
require 'colored'
require 'set'

module FileLister 

    def self::__filter_path_by(path)
        (path != '.') and (path != '..')
    end

    def self::list_all_files(folder = __dir__)
        result = []
        Dir.entries(folder)
            .filter() do
                __filter_path_by(_1)
            end
            .each do |path|
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

    def self::list_all_rb_files
        list_all_files.filter do |f|
            f.end_with? ".rb"
        end

    end
end


class Autoloader 
    
    attr_accessor :all_files, :done, :failed, :todo_stack
    
    def initialize()
        self.all_files = FileLister::list_all_rb_files() 
        self.done = Set.new
        self.failed = {}
        self.todo_stack = []
    end


    def to_load 
        all_files - done.to_a
    end

    def try_one(path)
        puts "loading: #{path}".green

        begin 
            require_relative(path)
            done << path
        rescue => e
            failed[path] = e
            puts "skipping #{path}".red 
        end

    end

    def update_todo_stack()
        todo_stack << to_load.clone
        if todo_stack.size > 2 then 
            self.todo_stack = todo_stack[1..]
        end
    end

    def files_repeats() 
        return false if to_load.empty?

        return false if todo_stack.size < 2 
           
        return todo_stack.first == todo_stack.last
    end

    def stop_condition 
        to_load.empty? or files_repeats()
    end

    
    def show_errors 
        to_load().each do 
            puts "ERROR at #{_1}".yellow
            puts failed[_1]
            puts
        end
    end

    def load 
        begin 
            puts "Trying again".blue unless failed.empty?
            self.to_load.each do |path| 
                try_one(path)
            end
            puts 
            update_todo_stack()
        end until stop_condition()


        show_errors() unless to_load.empty?
    end

end


