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
        let!(:game) { create :game }
        let(:current_alley) { game.alleys.find_by(current_throw: true) }
        let(:current_frame) { current_alley.frames.find_by(current: true) }

        it 'current_frame.current will be false' do
            current_alley.complete(current_frame.number, 'X', 10)
            current_frame.reload

            expect(current_frame.current).to eq false
        end

        it 'next_frame.current will be true' do
            current_alley.complete(current_frame.number, 'X', 10)

            expect(current_alley.frames.find_by(number: current_frame.number + 1).current).to eq true
        end

        context 'after 10th frame' do
            let(:last_frame) { game.alleys.find_by(current_throw: true).frames.find_by(number: 10) }
            before do
                current_alley.frames.find_by(current: true).update(current: false)
                last_frame.update(current: true)
            end

            it 'will be no current frames' do
                current_alley.complete(last_frame.number, 'X', 10)

                expect(current_alley.frames.where(current: true).count).to eq 0
            end
        end
    end

    context '.check_points' do
        let!(:game) { create :game }
        let(:current_alley) { game.alleys.find_by(current_throw: true) }
        before do
            [10, 10, 7, 3, 2, 0, 10].each do |hit|
                current_frame = current_alley.frames.find_by(current: true)
                create :throw, frame: current_frame, alley: current_alley, pins: hit
                if hit == 10
                    current_alley.complete(current_frame.number, 'X', 10)
                elsif hit == 7 || hit == 2
                    current_frame.update(pins: hit, result: hit)
                else
                    current_alley.complete(current_frame.number, "#{current_frame.throws.first.pins}/#{current_frame.throws.last.pins}", current_frame.throws.first.pins + hit)
                end
            end
            current_alley.check_points
        end

        it 'has 5 completed frames for scoring' do
            expect(current_alley.frames.where(completed: true).count).to eq 5
        end

        it 'first frame has 27 points' do
            expect(current_alley.frames.with_number(1).points).to eq 27
        end

        it 'second frame has 20 points' do
            expect(current_alley.frames.with_number(2).points).to eq 20
        end

        it 'third frame has 12 points' do
            expect(current_alley.frames.with_number(3).points).to eq 12
        end

        it 'fourth frame has 2 points' do
            expect(current_alley.frames.with_number(4).points).to eq 2
        end

        it 'fifth frame has 10 points' do
            expect(current_alley.frames.with_number(5).points).to eq 10
        end

        it 'and total is 71 points' do
            expect(current_alley.points).to eq 71
        end

        context 'for next 4 frames' do
            before do
                [10, 10, 10, 10, 6, 4, 5].each do |hit|
                    current_frame = current_alley.frames.find_by(current: true)
                    create :throw, frame: current_frame, alley: current_alley, pins: hit
                    if hit == 10
                        current_alley.complete(current_frame.number, 'X', 10)
                    elsif hit == 6
                        current_frame.update(pins: hit, result: hit)
                    elsif hit == 4
                        current_frame.update(pins: current_frame.pins + hit, result: "#{current_frame.result}/#{hit}")
                    else
                        current_alley.complete(current_frame.number, "#{current_frame.result} #{hit}", current_frame.pins + hit)
                    end
                end
                current_alley.check_points
            end

            it 'eigth frame has 26 points' do
                expect(current_alley.frames.with_number(8).points).to eq 26
            end

            it 'ninth frame has 20 points' do
                expect(current_alley.frames.with_number(9).points).to eq 20
            end

            it 'tenth frame has 15 points' do
                expect(current_alley.frames.with_number(10).points).to eq 15
            end

            it 'and total is 212 points' do
                expect(current_alley.points).to eq 212
            end
        end
    end

    context '.change_alley' do
        let!(:game) { create :game }
        let(:alleys) { game.alleys.order(id: :asc) }
        let(:current_alley) { alleys.find_by(current_throw: true) }

        it 'next alley will be with current_throw' do
            current_alley.change_alley

            expect(current_alley.current_throw).to eq false
            expect(alleys.where('id > ?', current_alley.id).order(id: :asc).first.current_throw).to eq true
        end

        context 'for last alley' do
            before do
                current_alley.update(current_throw: false)
                alleys.last.update(current_throw: true)
            end

            it 'first alley will be with current_throw if current_alley is last' do
                alleys.last.change_alley

                expect(alleys.first.current_throw).to eq true
            end

            it 'game complete if last alley has 10 completed frames' do
                alleys.last.frames.update_all(completed: true)
                alleys.last.change_alley
                game.reload

                expect(game.completed).to eq true
            end
        end
    end
end