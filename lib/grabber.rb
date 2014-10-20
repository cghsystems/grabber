require 'capybara'
require 'selenium-webdriver'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'pageobjects/login'
require 'pageobjects/account_navigation'
require 'pageobjects/account_exporter'
require 'transform/csv_directory_to_json_file_converter'

def set_up_capybara
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  Capybara.default_driver = Capybara.javascript_driver = :chrome
end

#set_up_capybara

#PageObjects::Login.new.login
#PageObjects::AccountNavigation.new.go_to_gold_account
#PageObjects::AccountExporter.new.export_all_records

CSV_DIRECTORY = './downloads'
OUTPUT_FILE = 'finances2.json'
Transform::CsvDirectoryToJsonFileConverter.new.convert_csv_files_to_json(CSV_DIRECTORY, OUTPUT_FILE)




