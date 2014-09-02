class DateIterator

  def for_years(args, &block)
    from = args.fetch(:from)
    to = args.fetch(:to)
    raise ArgumentError if from > to
    each_year(from, to) do |year|
      each_month do |month, month_index|
        days = number_of_days_for_month(month, year)  
        yield days, month_index, year
      end
    end     
  end   

  private 

  def each_month(&block)
    (1..12).each do |index|
      yield Date::MONTHNAMES[index], index
    end
  end

  def each_year(from, to, &block)
    (from..to).each do |year|
      yield year
    end 
  end

  def number_of_days_for_month(month, year)
    month = Date::MONTHNAMES.find_index(month)
    Date.new(year, month,-1).strftime('%d').to_i
  end  

end
