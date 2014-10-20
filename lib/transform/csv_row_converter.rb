module Transform
  class CsvRowConverter

    def to_hash(csv)
      csv.map { |row|
        convert_to_hash(row)
      }
    end

    private

    def convert_to_hash(row)
      if row.size == 8
        convert_well_formed_row_to_hash(row)
      elsif row.size == 9
        convert_malformed_9_field_row_to_hash(row)
      elsif row.size == 10
        convert_malformed_10_field_row_to_hash(row)
      end
    end

    def convert_malformed_10_field_row_to_hash(row)
      new_row = []
      new_row[0] = transaction_date(row)
      new_row[1] = transaction_type(row)
      new_row[2] = sort_code(row)
      new_row[3] = account_number(row)
      new_row[4] = transaction_description("#{row[4]}#{row[5]}#{row[6]}")
      new_row[5] = debit_amount(row[7])
      new_row[6] = credit_amount(row[8])
      new_row[7] = account_balance(row[9])

      row = CSV::Row.new(row.headers, new_row, row.header_row?,)
      row.delete(8)
      row.delete(9)
      row.to_h
    end

    def convert_malformed_9_field_row_to_hash(row)
      new_row = []
      new_row[0] = transaction_date(row)
      new_row[1] = transaction_type(row)
      new_row[2] = sort_code(row)
      new_row[3] = account_number(row)
      new_row[4] = transaction_description("#{row[4]}#{row[5]}")
      new_row[5] = debit_amount(row[6])
      new_row[6] = credit_amount(row[7])
      new_row[7] = account_balance(row[8])

      row = CSV::Row.new(row.headers, new_row, row.header_row?,)
      row.delete(8)
      row.to_h
    end


    def convert_well_formed_row_to_hash(row)
      new_row = []
      new_row[0] = transaction_date(row)
      new_row[1] = transaction_type(row)
      new_row[2] = sort_code(row)
      new_row[3] = account_number(row)
      new_row[4] = transaction_description(row[4])
      new_row[5] = debit_amount(row[5])
      new_row[6] = credit_amount(row[6])
      new_row[7] = account_balance(row[7])

      row = CSV::Row.new(row.headers, new_row, row.header_row?,)
      row.to_h
    end

    def account_balance(account_balance)
      account_balance.to_f
    end

    def credit_amount(credit_amount)
      credit_amount.to_f
    end

    def debit_amount(debit_amount)
      debit_amount.to_f
    end

    def transaction_description(transaction_description)
      transaction_description.strip!
    end

    def account_number(row)
      row[3]
    end

    def sort_code(row)
      row[2]
    end

    def transaction_type(row)
      row[1]
    end

    def transaction_date(row)
      DateTime.parse(row[0]).rfc3339
    end

  end
end
