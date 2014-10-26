require 'spec_helper'

RSpec.shared_examples 'a financial record' do
  it 'contains the expected number of elements' do
    expect(csv_record_converter.size).to eql(1)
  end

  it 'contains the expected number of elements' do
    expect(record.size).to eql(8)
  end

  it 'contains the expected account number' do
    expect(record.fetch(:account_number)).to eql('1234567')
  end

  it 'contains the expected sort code' do
    expect(record.fetch(:sort_code)).to eql('99-99-99')
  end

  it 'contains the transaction date in rfc-3339 date format' do
    transaction_date = record.fetch(:transaction_date)
    expect { Date.parse(transaction_date) }.to_not raise_error
    expect(transaction_date.length).to eql(25)
  end

  it 'contains the expected transaction type' do
    expect(record.fetch(:transaction_type)).to eql('DEB')
  end

  it 'contains the expected transaction description' do
    expect(record.fetch(:transaction_description)).to eql('WM MORRISON 076 CD 0329')
  end

  it 'contains the expected debit amount' do
    expect(record.fetch(:debit_amount)).to eql(10.01)
  end

  it 'contains the expected credit amount' do
    expect(record.fetch(:credit_amount)).to eql(0.0)
  end

  it 'contains the expected balance' do
    expect(record.fetch(:balance)).to eql(-1413.64)
  end
end

describe Transform::CsvRowConverter do

  let(:csv) { CSV.new(csv_src, :headers => true, :header_converters => :symbol, :unconverted_fields => true) }
  let(:csv_record_converter) { subject.to_hash(csv) }
  let(:record) { csv_record_converter.first }

  context('a single well formed 8 field csv record') do
    let(:csv_src) {
      <<csv
Transaction Date,Transaction Type,Sort Code,Account Number,Transaction Description,Debit Amount,Credit Amount,Balance
30/06/2005,DEB,99-99-99,1234567,WM MORRISON 076 CD 0329 ,10.01,0,-1413.64
csv
    }

    it_behaves_like 'a financial record'

  end

  context('a single malformed 9 field csv record') do

    let(:csv_src) {
      <<csv
Transaction Date,Transaction Type,Sort Code,Account Number,Transaction Description,Debit Amount,Credit Amount,Balance
30/06/2005,DEB,99-99-99,1234567,WM MORRISON 076, CD 0329 ,10.01,0,-1413.64
csv
    }

    it_behaves_like 'a financial record'

  end

  context('a single malformed 10 field csv record') do

    let(:csv_src) {
      <<csv
Transaction Date,Transaction Type,Sort Code,Account Number,Transaction Description,Debit Amount,Credit Amount,Balance
30/06/2005,DEB,99-99-99,1234567,WM MORRISON 076, CD 0329 ,10.01,0,-1413.64
csv
    }

    it_behaves_like 'a financial record'

  end

  context 'nil credit, balance and credit amount' do

    let(:csv_src) {
      <<csv
Transaction Date,Transaction Type,Sort Code,Account Number,Transaction Description,Debit Amount,Credit Amount,Balance
30/06/2005,DEB,99-99-99,1234567,WM MORRISON 076 CD 0329,,,
csv
    }

    it 'should have 0 balance amount' do
      expect(record.fetch(:balance)).to eql(0.0)
    end

    it 'should have 0 credit amount' do
      expect(record.fetch(:credit_amount)).to eql(0.0)
    end

    it 'should have 0 debit amount' do
      expect(record.fetch(:debit_amount)).to eql(0.0)
    end
  end

end

