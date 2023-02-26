class StatsFormatter

    attr_accessor :stats

    def initialize(stats)
        @stats = stats
    end

    def self::create()
        StatsFormatter.new([])
    end

    def __is_empty(value)
        return true if value == nil
        return true if value.is_a? Numeric and value <= 0
    end

    def add(name, value)
        return self if __is_empty(value)
        return StatsFormatter.new([
            *@stats, { name => value }
        ])

    end

    def format
        stats
            .map do "#{_1.keys.first}: #{_1.values.first}" end
            .join("\n")
    end

end

