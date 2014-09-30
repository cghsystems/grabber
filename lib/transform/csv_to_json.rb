require 'csv'
require 'json'

module Transform
  class CsvToJson

    def convert_csv_files_to_json(download_dir, output_file)
      json = convert_each_csv_in_dir_to_json(download_dir)
      File.open(output_file, 'w') { |file| file.write json }
      puts "Created #{output_file}"
    end

    private

    def convert_each_csv_in_dir_to_json(download_dir)
      json_results = []
      Dir.foreach(download_dir) do |csv_file|
        next if ignore_file?(csv_file)
        file = "#{download_dir}/#{csv_file}"
        clean(file)
        json_results << csv_to_json(file)
      end
      json_results.flatten!.to_json
    end

    def csv_to_json(csv_file_path)
      puts "Processing #{csv_file_path}"
      file = File.open(csv_file_path)
      csv = CSV.new(file, :headers => true, :header_converters => :symbol, :converters => :all)

      csv.map { |row|
        if row.size == 9
          new_row = []
          new_row[0] = row[0]
          new_row[1] = row[1]
          new_row[2] = row[2]
          new_row[3] = row[3]
          new_row[4] = "#{row[4]} #{row[5]}"
          new_row[5] = row[6]
          new_row[6] = row[7]
          new_row[7] = row[8]
          row = CSV::Row.new(row.headers, new_row, row.header_row?, )
          row.delete(8)
        elsif row.size == 10
          new_row = []
          new_row[0] = row[0]
          new_row[1] = row[1]
          new_row[2] = row[2]
          new_row[3] = row[3]
          new_row[4] = "#{row[4]} #{row[5]} #{row[6]}"
          new_row[5] = row[7]
          new_row[6] = row[8]
          new_row[7] = row[9]
          row = CSV::Row.new(row.headers, new_row, row.header_row?, )
          row.delete(8)
          row.delete(9)
        end
        row.to_h
      }
    end

    private

    def ignore_file?(file)
      file == '.' or file == '..' or file == '.DS_Store'
    end

    # The CSV file is not the cleanest so we need to tweak it before parsing
    def clean(file_name)
      cleaned_file = File.read(file_name)
      cleaned_file = cleaned_file
      .gsub(/'30-25-80/, '30-25-80')
      .gsub(/30-25-80'/, '30-25-80')
      .gsub(/Balance,/, 'Balance')
      .gsub(/"/, "")
      File.open(file_name, "w") { |file| file.puts cleaned_file }
    end

  end
end
