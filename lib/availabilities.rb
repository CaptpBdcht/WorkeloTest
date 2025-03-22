require 'date'

# In order to add a duration for an opening, we can just:
#   - add a new parameter (e.g. duration) in the initialize method
#   - do not add openings that are smaller than this parameter
# IMHO this should be the responsibility of the caller, not the class
class Availabilities
  
  def initialize(start_hour, end_hour)
    @start_hour = start_hour
    @end_hour = end_hour
  end

  def forCalendars(
    calendars,
    start_date = '2020-09-01',
    end_date = '2020-09-01'
  )
    start_time = DateTime.parse(start_date)
    end_time = DateTime.parse(end_date)

    if calendars.empty? then
      return [
        toNormalizedDates([
          at_start_hour(start_time),
          at_end_hour(end_time)
        ])
      ]
    end

    availabilities = []
    one_day = 1.to_f

    start_time.step(end_time, one_day).each do |day|
      openings = [
        [at_start_hour(day), at_end_hour(day)]
      ]

      calendars.each do |calendar|
        calendar.each do |busy_time|
          openings = openings.flat_map do |opening|
            intersection = DateRange.intersection(
              opening,
              [
                DateTime.parse(busy_time[:start]),
                DateTime.parse(busy_time[:end])
              ]
            )

            if intersection.nil? then
              [opening]
            else
              DateRange.disjunctive_union(opening, intersection)
            end
          end
        end
      end

      availabilities.concat(openings.map { |o| toNormalizedDates(o) })
    end
      
    return availabilities
  end

  private def at_start_hour(date)
    DateTime.new(
      date.year,
      date.month,
      date.day,
      @start_hour
    )
  end

  private def at_end_hour(date)
    DateTime.new(
      date.year,
      date.month,
      date.day,
      @end_hour
    )
  end
  
  private def toNormalizedDates(range)
    {
      start: range.first.strftime('%Y-%m-%dT%H:%M:%S'),
      end: range.last.strftime('%Y-%m-%dT%H:%M:%S')
    }
  end
end
