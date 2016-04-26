RSpec.describe Frame, type: :model do
    it { should belong_to :alley }
    it { should have_many :throws }
    it { should validate_presence_of :alley_id }
    it { should validate_presence_of :number }
    it { should validate_presence_of :pins }
    it { should validate_inclusion_of(:number).in_range(1..10) }

    it 'should be valid' do
        frame = create :frame

        expect(frame).to be_valid
    end
end