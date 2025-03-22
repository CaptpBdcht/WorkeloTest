class DateRange
  def self.disjunctive_union(origin, other)
    return [ origin ] if other.nil?

    intersection = intersection(origin, other)
    return [ origin ] if intersection.nil?

    if (origin.first < other.first && other.last < origin.last) then
      return [
        [origin.first, other.first],
        [other.last, origin.last]
      ]
    end

    if (other.first <= origin.first && other.last < origin.last) then
      return [
        [other.last, origin.last]
      ]
    end

    if (origin.first < other.first && origin.last <= other.last) then
      return [
        [origin.first, other.first]
      ]
    end

    []
  end  

  def self.intersection(origin, other)
    return nil if (origin.last <= other.first or other.last <= origin.first) 
    [
      [origin.first, other.first].max,
      [origin.last, other.last].min
    ]
  end
end
