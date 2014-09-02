require 'csv_to_json'

describe CsvToJson do

  context('File exists') do

    let(:csv_file_path) { File.expand_path(File.join(File.dirname(__FILE__), 'assets',  'example.csv'))  }
    let(:csv_error_file_path) { File.expand_path(File.join(File.dirname(__FILE__), 'assets',  'example_error.csv'))  }

    context('#csv_to_json') do

      it 'should be parseable json' do
        expect { JSON.parse(subject.csv_to_json(csv_file_path)) }.to_not raise_error
      end    

      it 'should contain the expected elements' do
        json = JSON.parse(subject.csv_to_json(csv_file_path))
        expect(json.size).to eql(105)
        File.write('/tmp/records.json', json.to_json)
      end 

      it 'should riase error of the csv file does not exist' do
        expect { subject.csv_to_json('wibble.csv') }.to raise_error Errno::ENOENT
      end 

    end   
  end
end
