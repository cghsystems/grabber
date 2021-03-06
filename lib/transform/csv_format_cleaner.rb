module Transform
  class CsvFormatCleaner

    # The CSV files are not guaranteed to be clean and well formed after download
    # Therefore spurious characters are removed to make the csv content easier to
    # manipulate
    def clean(data)
      data.gsub(/'99-99-99/, '99-99-99')
      .gsub(/99-99-99'/, '99-99-99')
      .gsub(/Balance,/, 'Balance')
      .gsub(/"/, "")
    end
  end
end
