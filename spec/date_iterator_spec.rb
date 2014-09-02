require 'date_iterator'

describe DateIterator do

  it 'should raise error if to year is lower than from year' do
    expect { subject.for_years(from: 2013, to: 2012) }.to raise_error
  end  

  it 'should yield year, months, and year for leap year' do
    expected = expected_dates(leap_year: true)
    subject.for_years(from: 2012, to: 2012) do |day, month, year|
      days = expected.delete(month)
      expect(day).to eql(days)
    end
    expect(expected).to be_empty
  end

  it 'should yield year, months, and year for non leap year' do
    expected = expected_dates(leap_year: false)
    subject.for_years(from: 2013, to: 2013) do |day, month, year|
      days = expected.delete(month)
      expect(day).to eql(days)
    end
    expect(expected).to be_empty
  end


  it 'should yield dates for multiple years' do
    actual = 0
    subject.for_years(from: 2012, to: 2013) do |day, month, year|
      actual += 1
    end
    expect(actual).to eql(24)
  end   


  private 

  def expected_dates(args)
    leap_year = args.fetch(:leap_year)
    feb_days = leap_year ? 29 : 28
    {
      'January' => 31,
      'February' => feb_days,
      'March' => 31,
      'April' => 30,
      'May' => 31,
      'June' => 30,
      'July' => 31,
      'August' => 31,
      'September' => 30,
      'October' => 31,
      'November' => 30,
      'December' => 31    
    }
  end

end
