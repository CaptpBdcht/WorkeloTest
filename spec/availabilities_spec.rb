require 'availabilities'

# - Given 'busy calendars' are considered ordered in the exercice
# - Availabilities work for any number of calendars (0..n)
# - Start & End dates should always be given at usage
RSpec.describe Availabilities do

  before(:all) do
    @availabilities = Availabilities.new(9, 18)
  end

  it 'returns the whole day if no calendars are provided' do
    expect(@availabilities.forCalendars([])).to eq([
      {
        start: '2020-09-01T09:00:00',
        end: '2020-09-01T18:00:00'
      }
    ]);
  end

  context 'when 1 calendar is provided' do
    it 'returns availabilities from 9am to 6pm' do
      no_busy_time = [];

      expect(@availabilities.forCalendars([ no_busy_time ])).to eq([
        {
          start: '2020-09-01T09:00:00',
          end: '2020-09-01T18:00:00'
        }
      ]);
    end

    it 'removes busy times at limits' do
      busy_at_9am_and_5pm = [
        {
          start: '2020-09-01T09:00:00',
          end: '2020-09-01T10:00:00'
        },
        {
          start: '2020-09-01T17:00:00',
          end: '2020-09-01T18:00:00'
        }
      ];

      expect(@availabilities.forCalendars([ busy_at_9am_and_5pm ])).to eq([
        {
          start: '2020-09-01T10:00:00',
          end: '2020-09-01T17:00:00'
        }
      ]);
    end

    it 'removes busy time inside a day' do
      busy_from_10am_to_3pm = [
        {
          start: '2020-09-01T10:00:00',
          end: '2020-09-01T15:00:00'
        }
      ];

      expect(@availabilities.forCalendars([ busy_from_10am_to_3pm ])).to eq([
        {
          start: '2020-09-01T09:00:00',
          end: '2020-09-01T10:00:00'
        },
        {
          start: '2020-09-01T15:00:00',
          end: '2020-09-01T18:00:00'
        }
      ]);
    end

    it 'handles different slots (!= 1 hour) for one day' do
      busy_slots = [
        {
          start: '2020-09-01T09:15:00',
          end: '2020-09-01T17:42:00'
        }
      ]

      expect(@availabilities.forCalendars([ busy_slots ])).to eq([
        {
          start: '2020-09-01T09:00:00',
          end: '2020-09-01T09:15:00'
        },
        {
          start: '2020-09-01T17:42:00',
          end: '2020-09-01T18:00:00'
        }
      ])
    end

    it 'handles complex cases for one day' do
      busy_slots = [
        {
          start: '2020-09-01T08:00:00',
          end: '2020-09-01T10:00:00'
        },
        {
          start: '2020-09-01T12:00:00',
          end: '2020-09-01T14:00:00'
        },
        {
          start: '2020-09-01T16:00:00',
          end: '2020-09-01T17:00:00'
        }
      ];

      expect(@availabilities.forCalendars([ busy_slots ])).to eq([
        {
          start: '2020-09-01T10:00:00',
          end: '2020-09-01T12:00:00'
        },
        {
          start: '2020-09-01T14:00:00',
          end: '2020-09-01T16:00:00'
        },
        {
          start: '2020-09-01T17:00:00',
          end: '2020-09-01T18:00:00'
        }
      ]);
    end

    it 'returns availabilities for multiple days' do
      busy_slots = [
        {
          start: '2020-09-01T08:00:00',
          end: '2020-09-01T12:00:00'
        },
        {
          start: '2020-09-02T12:00:00',
          end: '2020-09-02T18:00:00'
        }
      ]

      expect(@availabilities.forCalendars(
        [busy_slots],
        '2020-09-01T00:00:00',
        '2020-09-02T00:00:00'
      )).to eq([
        {
          start: '2020-09-01T12:00:00',
          end: '2020-09-01T18:00:00'
        },
        {
          start: '2020-09-02T09:00:00',
          end: '2020-09-02T12:00:00'
        }
      ])
    end
  end

  context 'when more than 1 calendar is provided' do
    it 'simple case on one day' do
      busy_at_9am = [
        {
          start: '2020-09-01T09:00:00',
          end: '2020-09-01T10:00:00'
        }
      ];

      busy_at_17pm = [
        {
          start: '2020-09-01T17:00:00',
          end: '2020-09-01T18:00:00'
        }
      ]

      expect(@availabilities.forCalendars([ busy_at_9am, busy_at_17pm ])).to eq([
        {
          start: '2020-09-01T10:00:00',
          end: '2020-09-01T17:00:00'
        }
      ]);
    end

    it 'complex case on one day' do
      busy_inside = [
        {
          start: '2020-09-01T11:00:00',
          end: '2020-09-01T15:00:00'
        }
      ];

      busy_outside = [
        {
          start: '2020-09-01T08:00:00',
          end: '2020-09-01T10:00:00'
        },
        {
          start: '2020-09-01T16:00:00',
          end: '2020-09-01T18:00:00'
        }
      ]

      expect(@availabilities.forCalendars([ busy_inside, busy_outside ])).to eq([
        {
          start: '2020-09-01T10:00:00',
          end: '2020-09-01T11:00:00'
        },
        {
          start: '2020-09-01T15:00:00',
          end: '2020-09-01T16:00:00'
        }
      ])
    end

    it 'complex case on multiple days' do
      busy_inside_day_one = [
        {
          start: '2020-09-01T10:00:00',
          end: '2020-09-01T15:00:00'
        }
      ];

      busy_on_limits_day_two = [
        {
          start: '2020-09-02T08:00:00',
          end: '2020-09-02T10:00:00'
        },
        {
          start: '2020-09-02T16:00:00',
          end: '2020-09-02T18:00:00'
        }
      ]

      expect(@availabilities.forCalendars(
        [ busy_inside_day_one, busy_on_limits_day_two ],
        '2020-09-01T00:00:00',
        '2020-09-02T00:00:00'
      )).to eq([
        {
          start: '2020-09-01T09:00:00',
          end: '2020-09-01T10:00:00'
        },
        {
          start: '2020-09-01T15:00:00',
          end: '2020-09-01T18:00:00'
        },
        {
          start: '2020-09-02T10:00:00',
          end: '2020-09-02T16:00:00'
        }
      ])
    end
  end

  it 'sandra and andy' do 
    busy_sandra = [
      {
        'start': '2022-08-01T09:00:00',
        'end': '2022-08-01T11:00:00'
      },
      {
        'start': '2022-08-01T12:00:00',
        'end': '2022-08-01T13:00:00'
      },
      {
        'start': '2022-08-01T15:00:00',
        'end': '2022-08-01T18:00:00'
      },
      {
        'start': '2022-08-02T09:00:00',
        'end': '2022-08-02T10:00:00'
      },
      {
        'start': '2022-08-02T12:00:00',
        'end': '2022-08-02T17:00:00'
      },
      {
        'start': '2022-08-03T13:00:00',
        'end': '2022-08-03T15:00:00'
      },
      {
        'start': '2022-08-03T16:00:00',
        'end': '2022-08-03T18:00:00'
      },
      {
        'start': '2022-08-04T09:00:00',
        'end': '2022-08-04T10:00:00'
      },
      {
        'start': '2022-08-04T12:00:00',
        'end': '2022-08-04T15:00:00'
      },
      {
        'start': '2022-08-04T16:00:00',
        'end': '2022-08-04T17:00:00'
      }
    ]

    busy_andy = [
      {
        'start': '2022-08-01T09:00:00',
        'end': '2022-08-01T14:00:00'
      },
      {
        'start': '2022-08-02T09:00:00',
        'end': '2022-08-02T14:00:00'
      },
      {
        'start': '2022-08-02T15:00:00',
        'end': '2022-08-02T17:00:00'
      },
      {
        'start': '2022-08-03T09:00:00',
        'end': '2022-08-03T18:00:00'
      },
      {
        'start': '2022-08-04T10:00:00',
        'end': '2022-08-04T15:00:00'
      },
      {
        'start': '2022-08-04T16:00:00',
        'end': '2022-08-04T17:00:00'
      }
    ]

    expect(@availabilities.forCalendars(
      [ busy_sandra, busy_andy ],
      '2022-08-01T00:00:00',
      '2022-08-04T00:00:00'
    )).to eq([
      {
        'start': '2022-08-01T14:00:00',
        'end': '2022-08-01T15:00:00'
      },
      {
        'start': '2022-08-02T17:00:00',
        'end': '2022-08-02T18:00:00'
      },
      {
        'start': '2022-08-04T15:00:00',
        'end': '2022-08-04T16:00:00'
      },
      {
        'start': '2022-08-04T17:00:00',
        'end': '2022-08-04T18:00:00'
      }
    ])
  end  
end

