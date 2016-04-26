RSpec.describe Game, type: :model do
    it { should have_many :alleys }

    it 'should be valid' do
        game = create :game

        expect(game).to be_valid
    end

    context '.set_throw' do
        it 'game should has 1 current alley' do
            game = create :game

            expect(game.alleys.where(current_throw: true).count).to eq 1
        end
    end
end
