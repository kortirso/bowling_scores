require_relative 'feature_helper'

RSpec.feature 'Navigation management', type: :feature do
    let!(:game) { create :game }
    before { visit root_path }

    it 'can visit main page' do
        click_on 'All Games'

        expect(page.has_content?("Game's list")).to eq true
    end

    it 'can visit specifix game' do
        click_on "Game ##{game.id}"

        expect(page.has_content?('Game scores')).to eq true
    end

    it 'can visit new game page' do
        click_on 'New Game'

        expect(page.has_content?('Game creation')).to eq true
    end

    context 'at new game page' do
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

    context 'at game page' do
        before { visit game_path(game) }

        it 'can throw kegel and result will be in table', js: true do
            fill_in 'throw_pins', with: '10'
            click_on 'Throw'

            expect(page.has_css?('table tbody tr:nth-of-type(1) td:nth-of-type(2)', text: 'X')).to eq true
        end
    end
end