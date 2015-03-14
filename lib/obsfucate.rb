require 'set'
require 'json'
require 'securerandom'


class Obsfucate

  def initialize(json)
    @json = json
    @unique_transaction_records  = json.uniq { |i| i['transaction_description'] }
    @unique_transaction_names = unique_transaction_records.map { |i| i['transaction_description'] }
    @obsfucated_names = unique_transaction_names.map { SecureRandom.hex }
  end

  def obsfucate_data
    json.each do |r|
      obsfucate_field(r, 'sort_code')  { '12-12-12'}
      obsfucate_field(r, 'account_number') { '1234567' }

      obsfucate_field(r, 'transaction_description') do |current_trasaction_name|
       if current_trasaction_name.include? 'TESCO'
        current_trasaction_name
       elsif
        index =  unique_transaction_names.index(current_trasaction_name)
        obsfucated_names.fetch(index)
       end
      end

      obsfucate_field(r, 'debit_amount') do |current_debit_amount|
        new_value = current_debit_amount * SecureRandom.random_number(10)
        new_value.round(2)
      end

      obsfucate_field(r, 'credit_amount') do |current_credit_amount|
        new_value = current_credit_amount * SecureRandom.random_number(10)
        new_value.round(2)
      end

      obsfucate_field(r, 'balance') do |current_balance|
        new_value = current_balance * SecureRandom.random_number(10)
        new_value.round(2)
      end
    end 
  end
  
  private

  attr_reader :json, :unique_transaction_records, :unique_transaction_names, :obsfucated_names

  def obsfucate_field(r, target_field, &block)
    raise 'No block give' unless block
    original_value = r[target_field]
    new_value = yield original_value
    r[target_field] = new_value
  end
end
