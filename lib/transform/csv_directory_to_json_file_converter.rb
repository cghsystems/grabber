require 'csv'
require 'json'
require 'time'

require 'transform/csv_row_converter'
require 'transform/csv_format_cleaner'

module Transform
  class CsvDirectoryToJsonFileConverter

    def initialize(csv_row_converter = Transform::CsvRowConverter.new, format_cleaner = Transform::CsvFormatCleaner.new)
      @csv_row_converter = csv_row_converter
      @format_cleaner = format_cleaner
    end

    def convert_csv_files_to_json(download_dir, output_file)
      json = convert_each_csv_in_dir_to_json(download_dir)
      File.open(output_file, 'w') { |file| file.write json }
      puts "Created #{output_file}"
    end

    private

    attr_reader :csv_row_converter, :format_cleaner

    def convert_each_csv_in_dir_to_json(download_dir)
      json_results = []
      Dir.foreach(download_dir) do |csv_file|
        file_name = "#{download_dir}/#{csv_file}"
        if File.extname(file_name) == '.csv'
          json_results << convert_csv_file_to_hash(file_name)
        end
      end
      json_results.flatten!.to_json
    end

    def convert_csv_file_to_hash(csv_file_path)
      csv_src = File.read(csv_file_path)
      format_cleaner.clean(csv_src)
      csv = CSV.new(csv_src, :headers => true, :header_converters => :symbol, :unconverted_fields => true)
      csv_row_converter.to_hash(csv)
    end
  end
end
