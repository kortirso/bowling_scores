RSpec.describe Throw, type: :model do
    it { should belong_to :frame }
    it { should belong_to :alley }
    it { should validate_presence_of :frame_id }
    it { should validate_presence_of :alley_id }
    it { should validate_presence_of :pins }
    it { should validate_inclusion_of(:pins).in_range(0..10) }

    it 'should be valid' do
        _throw = create :throw

        expect(_throw).to be_valid
    end

    context 'self.build(game_id, pins)' do
        let!(:game) { create :game }
        let(:current_alley) { game.alleys.find_by(current_throw: true) }

        it 'doesnot create throw if hit more than 10' do
            expect { Throw.build(game.id, 11) }.to_not change(current_alley.throws, :count)
        end

        it 'doesnot create throw if hit less than 0' do
            expect { Throw.build(game.id, -1) }.to_not change(current_alley.throws, :count)
        end

        it 'creates throw if hit in array from 0 to 10' do
            expect { Throw.build(game.id, 10) }.to change(current_alley.throws, :count).by(1)
        end
    end
end
