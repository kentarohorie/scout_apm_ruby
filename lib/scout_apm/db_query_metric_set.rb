module ScoutApm
  class DbQueryMetricSet
    attr_reader :metrics

    def initialize
      @metrics = Hash.new
    end

    def lookup(other)
      metrics[other.key] ||= other
    end

    def combine!(other)
      lookup(other).combine!(other)
    end

    # Takes an array of ActiveRecord layers, creates new DbQueryMetricStats and combines them into this Set.
    # This might be a bit much overhead. Make a new method that can report/combine the raw numbers without
    # the intermediate creation of a DbQueryMetricStats object
    def absorb_layers!(database_layers)
      database_layers.each do |l|
        db_query_metric_stats = DbQueryMetricStats.new(l.name.model, l.name.normalized_operation, 1, l.total_call_time, l.annotations[:record_count])
        combine!(db_query_metric_stats)
      end
    end
  end
end
