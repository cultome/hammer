module Hammer
  module Statisticable
    def stats
      case type.name
      when "integer" then numeric_stats
      when "float" then numeric_stats
      when "string" then string_stats
      when "date" then date_stats
      end
    end

    private

    def numeric_stats
      hash = {
        count: Hash.new { |h, k| h[k] = 0 },
        sum: 0,
        max: 0,
        invalid: 0,
        min: 999999999,
      }

      list = []
      stats = data.each_with_object(hash) do |num, acc|
        if num.nil?
          acc[:invalid] += 1
          next
        end

        list << num

        acc[:count][num] += 1
        acc[:sum] += num
        acc[:max] = num if acc[:max] < num
        acc[:min] = num if acc[:min] > num
      end

      stats[:avg] = stats[:sum] / size
      stats[:median] = list.sort[list.size / 2]

      stats.delete(:count) if stats[:count].size > 10
      stats.delete(:invalid) if stats[:invalid].zero?

      stats
    end

    def string_stats
      return if data.uniq.size > data.size * 0.1

      hash = Hash.new { |h, k| h[k] = 0 }
      stats = data.each_with_object(hash) do |val, acc|
        hash[val] += 1
      end

      Hash[stats.sort_by { |k, v| v }.reverse]
    end

    def date_stats
      hash = {
        max: 0,
        min: 9999999999,
      }

      stats = data.each_with_object(hash) do |date, acc|
        unless date.nil?
          date_num = date.to_time.to_i

          acc[:max] = date_num if acc[:max] < date_num
          acc[:min] = date_num if acc[:min] > date_num
        end
      end

      stats[:min] = Time.at(stats[:min])
      stats[:max] = Time.at(stats[:max])

      stats
    end
  end
end
