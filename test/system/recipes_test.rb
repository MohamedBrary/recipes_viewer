require 'application_system_test_case'

class RecipesTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit recipes_url
    assert_selector 'h1', text: 'Listing Recipes'
  end

  test 'show a Recipe' do
    visit recipes_url
    click_on 'Show', match: :first

    assert_text 'Chef Name:'
    click_on 'Back'
  end

end
