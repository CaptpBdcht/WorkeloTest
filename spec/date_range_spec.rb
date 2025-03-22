require 'date_range'

RSpec.describe DateRange do
  context 'intersection' do 
    it 'returns origin when no intersection' do
      from_9_to_10 = ['2020-09-01T09:00:00', '2020-09-01T10:00:00']
      from_10_to_11 = ['2020-09-01T10:00:00', '2020-09-01T11:00:00']
      
      expect(DateRange.intersection(
        from_9_to_10, from_10_to_11
      )).to be_nil
    end

    it 'returns inside intersection when there is one' do
      from_9_to_12 = ['2020-09-01T09:00:00', '2020-09-01T12:00:00']
      from_10_to_11 = ['2020-09-01T10:00:00', '2020-09-01T11:00:00']
      
      expect(DateRange.intersection(
        from_9_to_12, from_10_to_11
      )).to eq from_10_to_11
    end

    it 'returns left intersection when there is one' do
      from_9_to_12 = ['2020-09-01T09:00:00', '2020-09-01T12:00:00']
      from_8_to_10 = ['2020-09-01T08:00:00', '2020-09-01T10:00:00']
      
      expect(DateRange.intersection(
        from_9_to_12, from_8_to_10
      )).to eq [
        '2020-09-01T09:00:00',
        '2020-09-01T10:00:00'
      ]
    end

    it 'returns right intersection when there is one' do
      from_9_to_12 = ['2020-09-01T09:00:00', '2020-09-01T12:00:00']
      from_10_to_14 = ['2020-09-01T10:00:00', '2020-09-01T14:00:00']
      
      expect(DateRange.intersection(
        from_9_to_12, from_10_to_14
      )).to eq [
        '2020-09-01T10:00:00',
        '2020-09-01T12:00:00'
      ]
    end
  end

  context 'disjunctive_union' do
    it 'returns origin when there is no intersection' do
      from_9_to_10 = ['2020-09-01T09:00:00', '2020-09-01T10:00:00']
      from_10_to_11 = ['2020-09-01T10:00:00', '2020-09-01T11:00:00']
      
      expect(DateRange.disjunctive_union(
        from_9_to_10, from_10_to_11
      )).to eq [ from_9_to_10 ]
    end

    it 'returns empty array when origin is fully intersected' do
      from_9_to_18 = ['2020-09-01T09:00:00', '2020-09-01T18:00:00']

      expect(DateRange.disjunctive_union(
        from_9_to_18, from_9_to_18
      )).to eq []
    end

    it 'returns two ranges when there is an intersection inside' do
      from_9_to_18 = ['2020-09-01T09:00:00', '2020-09-01T18:00:00']
      from_12_to_15 = ['2020-09-01T12:00:00', '2020-09-01T15:00:00']

      from_9_to_12 = ['2020-09-01T09:00:00', '2020-09-01T12:00:00']
      from_15_to_18 = ['2020-09-01T15:00:00', '2020-09-01T18:00:00']
      
      expect(DateRange.disjunctive_union(
        from_9_to_18, from_12_to_15
      )).to eq [ from_9_to_12, from_15_to_18 ]
    end

    it 'returns right range when there is an intersection at the start' do
      from_9_to_18 = ['2020-09-01T09:00:00', '2020-09-01T18:00:00']
      from_9_to_10 = ['2020-09-01T09:00:00', '2020-09-01T10:00:00']

      from_10_to_18 = ['2020-09-01T10:00:00', '2020-09-01T18:00:00']
      
      expect(DateRange.disjunctive_union(
        from_9_to_18, from_9_to_10
      )).to eq [ from_10_to_18 ]
    end

    it 'returns left range when there is an intersection at the end' do
      from_9_to_18 = ['2020-09-01T09:00:00', '2020-09-01T18:00:00']
      from_16_to_18 = ['2020-09-01T16:00:00', '2020-09-01T18:00:00']

      from_9_to_16 = ['2020-09-01T09:00:00', '2020-09-01T16:00:00']
      
      expect(DateRange.disjunctive_union(
        from_9_to_18, from_16_to_18
      )).to eq [ from_9_to_16 ]
    end
  end
end