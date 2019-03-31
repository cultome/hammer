
module Hammer::Statisticable
  def stats
    case type
    when "integer" then numeric_stats
    when "float" then numeric_stats
    when "string" then string_stats
    when "date" then date_stats
    end
  end

  private

  def numeric_stats
    hash = {
      count: Hash.new{|h,k| h[k] = 0},
      sum: 0,
      max: 0,
      min: 999999999,
    }

    stats = data.each_with_object(hash) do |num,acc|
      acc[:count][num] += 1

      unless num.nil?
        acc[:sum] += num
        acc[:max] = num if acc[:max] < num
        acc[:min] = num if acc[:min] > num
      end
    end

    stats[:avg] = stats[:sum] / size

    stats
  end

  def string_stats
  end

  def date_stats
    hash = {
      max: 0,
      min: 9999999999,
    }

    stats = data.each_with_object(hash) do |date,acc|
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
