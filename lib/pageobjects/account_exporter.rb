require 'date/date_iterator'

module PageObjects
  class AccountExporter

    include Capybara::DSL

    def export_all_records()
      DateIterator.new.for_years(from: 2002, to: 2014) do |day, month, year|
        export_records(from_month: month, from_year: year,
                       to_day: day, to_month: month, to_year: year)
      end
    end

    private

    def export_records(args)

      from_month = args.fetch(:from_month)
      from_year = args.fetch(:from_year)

      to_day = args.fetch(:to_day).to_s
      to_month = args.fetch(:to_month)
      to_year = args.fetch(:to_year)

      goto_export
      input_from_date(from_month, from_year)
      input_to_date(to_day, to_month, to_year)
      export

    end

    def export()
      click_on 'frmTest:btn_Export'
      sleep(5)
    end

    def goto_export
      find_by_id('pnlgrpStatement:conS1:lkoverlay').click
      sleep(2) 
    rescue
      click_on 'frmTest:lnkCancel1'
      goto_export
    end

    def input_from_date(from_month, from_year)
      find_by_id('frmTest:rdoDateRange:1').click
      find_by_id('frmTest:dtSearchFromDate').find("option[value='01']").select_option
      find_by_id('frmTest:dtSearchFromDate.month').find("option[value='#{"%02d" % from_month}']").select_option
      find_by_id('frmTest:dtSearchFromDate.year').find("option[value='#{from_year}']").select_option
    end

    def input_to_date(to_day, to_month, to_year)
      find_by_id('frmTest:rdoDateRange:1').click
      find_by_id('frmTest:dtSearchToDate').find("option[value='#{"%02d" % to_day}']").select_option
      find_by_id('frmTest:dtSearchToDate.month').find("option[value='#{"%02d" % to_month}']").select_option
      find_by_id('frmTest:dtSearchToDate.year').find("option[value='#{to_year}']").select_option
    end

  end
end
