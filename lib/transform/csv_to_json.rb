require 'csv'
require 'json'

module Transform
  class CsvToJson

    def convert_csv_files_to_json(download_dir, output_file)
      json = handle_dir(download_dir)
      File.open(output_file, 'w') { |file| file.write json }
    end

    private

    def handle_dir(download_dir)
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
      csv.map { |r| r.to_h }
    end

    private

    def ignore_file?(file)
      file == '.' or file == '..' or file == '.DS_Store'
    end

    # The CSV file is not the cleanest so we need to tweak it before parsing
    def clean(file_name)
      cleaned_file = File.read(file_name)
      cleaned_file = cleaned_file.gsub(/'30-25-80/, '30-25-80')
      .gsub(/30-25-80'/, '30-25-80')
      .gsub(/Balance,/, 'Balance')
      .gsub(/"/, "")
      File.open(file_name, "w") { |file| file.puts cleaned_file }
    end

  end
end
