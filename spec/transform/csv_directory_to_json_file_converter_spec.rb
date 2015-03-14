require 'spec_helper'

describe Transform::CsvDirectoryToJsonFileConverter do

  context '.convert_csv_files_to_json' do

    let(:json_output_file) do
      '/tmp/finances.json'
    end

    after(:all) do
      File.delete json_output_file
    end

    context 'assets/example.csv is correctly parsed' do
      let(:json_output) do
        subject.convert_csv_files_to_json(csv_directory, json_output_file)
        JSON.parse(File.read(json_output_file))
      end

      it 'should contain the expected number of elements' do
        expect(json_output.size).to eql(105)
      end

      it 'each record should contain the expected number of elements' do
        json_output.each do |record|
          expect(record.size).to eql(8)
        end
      end

      it 'each record should contain the expected account number' do
        json_output.each do |record|
          expect(record.fetch('account_number')).to eql('99-99-9967')
        end
      end

      it 'each record should contain the expected sort code' do
        json_output.each do |record|
          expect(record.fetch('sort_code')).to eql('99-99-99')
        end
      end

      it 'should have records with rfc-3339 date format' do
        json_output.each do |record|
          transaction_date = record.fetch('transaction_date')
          expect { Date.parse(transaction_date) }.to_not raise_error
        end
      end
    end

  end

end
