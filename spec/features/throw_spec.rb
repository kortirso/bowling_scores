require_relative 'feature_helper'

RSpec.feature 'Throw management', type: :feature do
    let!(:game) { create :game }
    before { visit game_path(game) }

    it 'can throw kegel and result will be in table', js: true do
        fill_in 'throw_pins', with: '10'
        click_on 'Throw'

        expect(page.has_css?('table tbody tr:nth-of-type(1) td:nth-of-type(2)', text: 'X')).to eq true
    end
end