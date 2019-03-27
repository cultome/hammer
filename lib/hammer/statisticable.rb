
module Hammer::Statisticable
  def stats
    case type
    when "integer" then integer_stats
    when "string" then string_stats
    when "date" then date_stats
    end
  end

  private

  def integer_stats
    hash = {
      count: Hash.new{|h,k| h[k] = 0}
    }

    data.each_with_object(hash) do |num,acc|
      acc[:count][num] += 1
    end
  end

  def string_stats
  end

  def date_stats
  end
end
