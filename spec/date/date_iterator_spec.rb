require 'spec_helper'

describe DateIterator do

  it 'should raise error if to year is lower than from year' do
    expect { subject.for_years(from: 2013, to: 2012) }.to raise_error
  end  

  it 'should yield year, months, and year for leap year' do
    expected = expected_dates(leap_year: true)
    subject.for_years(from: 2012, to: 2012) do |day, month_index, _|
      days = expected.delete(month_index)
      expect(days).to eql(day)
    end
    expect(expected).to be_empty
  end

  it 'should yield year, months, and year for non leap year' do
    expected = expected_dates(leap_year: false)
    subject.for_years(from: 2013, to: 2013) do |day, month_inedx, _|
      days = expected.delete(month_inedx)
      expect(days).to eql(day)
    end
    expect(expected).to be_empty
  end


  it 'should yield dates for multiple years' do
    actual = 0
    subject.for_years(from: 2012, to: 2013) do |_, _, _|
      actual += 1
    end
    expect(actual).to eql(24)
  end   


  private 

  def expected_dates(args)
    leap_year = args.fetch(:leap_year)
    feb_days = leap_year ? 29 : 28
    {
      1 => 31,
      2 => feb_days,
      3 => 31,
      4 => 30,
      5  => 31,
      6 => 30,
      7 => 31,
      8 => 31,
      9 => 30,
      10 => 31,
      11 => 30,
      12 => 31    
    }
  end

end
