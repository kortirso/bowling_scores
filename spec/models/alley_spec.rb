RSpec.describe Alley, type: :model do
    it { should belong_to :game }
    it { should have_many :frames }
    it { should validate_presence_of :points }
    it { should validate_presence_of :player }

    it 'should be valid' do
        alley = create :alley

        expect(alley).to be_valid
    end

    context '.create_frames' do
        let!(:game) { create :game }

        it 'each alley should has 10 frames' do
            game.alleys.each do |alley|
                expect(alley.frames.count).to eq 10
            end
        end

        it 'and only 1 current frame' do
            game.alleys.each do |alley|
                expect(alley.frames.where(current: true).count).to eq 1
            end
        end
    end

    context '.complete(frame_number, res, pins)' do

    end

    context '.check_points' do
        
    end

    context '.change_alley' do
        
    end
end