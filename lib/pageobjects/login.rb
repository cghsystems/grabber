require 'yaml'

module PageObjects
  class Login

    include Capybara::DSL

    def login
      user_id_and_password_step
      secret_phrase_step
    end

    private

    def user_id
      private_yaml.fetch('user_id')
    end

    def password
      private_yaml.fetch('password')
    end
    
    def secret
      private_yaml.fetch('secret')
    end   

    def private_yaml
      YAML.load_file(File.join(__dir__, '../../config/private.yml'))
    end

    def user_id_and_password_step()
      visit('https://online.lloydsbank.co.uk/personal/logon/login.jsp')
      fill_in 'frmLogin:strCustomerLogin_userID', :with => user_id
      fill_in 'frmLogin:strCustomerLogin_pwd', :with => password
      click_button 'frmLogin:btnLogin1'
    end

    def secret_phrase_step()
      select_secret_characters
      click_button 'frmentermemorableinformation1:btnContinue'
    end

    def select_secret_characters
      (1..3).each do |index|
        cell_id = "frmentermemorableinformation1:strEnterMemorableInformation_memInfo#{index}"
        character = get_character(cell_id)
        find_by_id(cell_id).find("option[value='&nbsp;#{character}']").select_option
      end
    end

    def get_character(cell_id)
      character = find(:xpath, "//label[@for='#{cell_id}']").text
      get = character.chars[10].to_i
      secret.chars[get-1]
    end

  end
end
