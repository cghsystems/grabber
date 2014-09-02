require 'capybara'
require 'selenium-webdriver'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'pageobjects/login'
require 'pageobjects/account_navigation'
require 'pageobjects/account_exporter'
require 'transform/csv_to_json'

def set_up_capybara
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  Capybara.default_driver = Capybara.javascript_driver = :chrome
end

set_up_capybara

PageObjects::Login.new.login
PageObjects::AccountNavigation.new.go_to_gold_account
PageObjects::AccountExporter.new.export_all_records

DOWNLOAD_DIR = '/Users/chris/Downloads'
OUTPUT_FILE = 'finances.json'
Transform::CsvToJson.new.convert_csv_files_to_json(DOWNLOAD_DIR, OUTPUT_FILE)




