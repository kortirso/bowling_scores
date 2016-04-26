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

    end
end
