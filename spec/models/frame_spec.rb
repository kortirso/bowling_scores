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

    context '.can_hit?(pins)' do
        let!(:game) { create :game }
        let(:current_frame) { game.alleys.find_by(current_throw: true).frames.find_by(current: true) }

        context 'in first 9 frames' do
            it 'first throw always can hit 10 kegels' do
                expect(current_frame.can_hit?(10)).to eq true
            end

            it 'second throw can hit all staying kegels' do
                Throw.build(game.id, 7)

                expect(current_frame.can_hit?(3)).to eq true
            end

            it 'and can not hit more kegels than staying' do
                Throw.build(game.id, 7)

                expect(current_frame.can_hit?(4)).to eq false
            end
        end

        context 'in 10th frame' do
            let(:last_frame) { game.alleys.find_by(current_throw: true).frames.find_by(number: 10) }

            it 'first throw always can hit 10 kegels' do
                expect(last_frame.can_hit?(10)).to eq true
            end

            context 'if first throw does not hit 10 kegels' do
                let!(:throw) { create :throw, frame: last_frame, alley: game.alleys.find_by(current_throw: true), pins: 7 }
                before { last_frame.update(pins: 7) }

                it 'second throw can hit all staying kegels' do
                    expect(last_frame.can_hit?(3)).to eq true
                end

                it 'and can not hit more kegels than staying' do
                    expect(last_frame.can_hit?(4)).to eq false
                end

                it 'can try to hit 10 kegels with third throw' do
                    create :throw, frame: last_frame, alley: game.alleys.find_by(current_throw: true), pins: 3
                    last_frame.update(pins: 10)

                    expect(last_frame.can_hit?(10)).to eq true
                end
            end

            context 'if first throw hit 10 kegels' do
                let!(:throw) { create :throw, frame: last_frame, alley: game.alleys.find_by(current_throw: true), pins: 10 }
                before { last_frame.update(pins: 10) }

                it 'second throw can hit 10 kegels' do
                    expect(last_frame.can_hit?(10)).to eq true
                end

                it 'third throw can hit 10 kegels if second throw hits 10' do
                    create :throw, frame: last_frame, alley: game.alleys.find_by(current_throw: true), pins: 10
                    last_frame.update(result: 'X X')

                    expect(last_frame.can_hit?(10)).to eq true
                end

                context 'third throw if second throw does not hit 10' do
                    before do
                        create :throw, frame: last_frame, alley: game.alleys.find_by(current_throw: true), pins: 7
                        last_frame.update(pins: 17)
                    end

                    it 'third throw can hit all staying kegels' do
                        expect(last_frame.can_hit?(3)).to eq true
                    end

                    it 'and can not hit more kegels than staying' do
                        expect(last_frame.can_hit?(4)).to eq false
                    end
                end
            end
        end
    end
end