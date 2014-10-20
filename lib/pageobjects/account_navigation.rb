module PageObjects
  class AccountNavigation

    include Capybara::DSL

    def go_to_gold_account
      goto_account('Gold Service')
    end

    private

    def goto_account(name)
      click_link name
    end

  end
end
