class StatsFormatter

    attr_accessor :stats 

    def initialize(stats) 
        @stats = stats
    end

    def self::create() 
        StatsFormatter.new([])
    end

    def add(name, value)
        return StatsFormatter.new([ 
            *@stats, { name => value }
        ]) if value  
        return self 
    end

    def format
        stats
            .map do "#{_1.keys.first}: #{_1.values.first}" end
            .join("\n")
    end

end
