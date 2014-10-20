require 'spec_helper'

describe Transform::CsvFormatCleaner do
  context '.clean' do
    it 'should clean sort code with no following quote' do
      expect(subject.clean("'30-25-80")).to eql("30-25-80")
    end

    it 'should clean sort code with no starting quote' do
      expect(subject.clean("30-25-80'")).to eql("30-25-80")
    end

    it 'should clean Balance string with following comma' do
      expect(subject.clean("Balance,")).to eql('Balance')
    end

    it 'should do nothing with string that does not need cleaning' do
      expect(subject.clean('30-25-80,Balance')).to eql('30-25-80,Balance')
    end

    it 'should convert all single quote to double quotes' do
      expect(subject.clean("\"")).to eql("")
    end
  end
end