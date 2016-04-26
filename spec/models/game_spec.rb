RSpec.describe Game, type: :model do
    it { should have_many :alleys }

    it 'should be valid' do
        game = create :game

        expect(game).to be_valid
    end
end
