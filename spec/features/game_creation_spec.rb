require_relative 'feature_helper'

RSpec.feature 'Game creation management', type: :feature do
    before { visit new_game_path }

    it 'can create game with players' do
        within '#new_game_alleys' do
            page.find('.alleys:nth-of-type(1)').fill_in 'game[alleys_attributes][0][player]', with: 'First'
        end
        click_on 'Create Game'

        expect(page.has_content?('Game scores')).to eq true
    end

    context 'for a few players' do
        before { click_on 'Add Player' }

        it 'it has 2 players lines', js: true do
            within '#new_game_alleys' do
                expect(page.all('.alleys').count).to eq 2
            end
        end

        it 'and they can be filled for game creation', js: true do
            within '#new_game_alleys' do
                page.find('.alleys:nth-of-type(1)').fill_in 'game[alleys_attributes][0][player]', with: 'First'
                page.find('.alleys:nth-of-type(2)').fill_in 'game[alleys_attributes][1][player]', with: 'Second'
            end
            click_on 'Create Game'

            expect(page.has_content?('Game scores')).to eq true
        end

        it 'and game not created if one line is not filled', js: true do
            within '#new_game_alleys' do
                page.find('.alleys:nth-of-type(1)').fill_in 'game[alleys_attributes][0][player]', with: 'First'
            end
            click_on 'Create Game'

            expect(page.has_content?("Game's list")).to eq true
        end
    end
end