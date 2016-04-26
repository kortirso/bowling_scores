class Throw < ActiveRecord::Base
    belongs_to :frame
    belongs_to :alley

    validates :frame_id, :alley_id, :pins, presence: true
    validates :pins, inclusion: { in: (0..10) }

    def self.build(game_id, pins)
        if pins >= 0 && pins <= 10
            current_alley = Game.find(game_id).alleys.order(id: :asc).find_by(current_throw: true)
            current_frame = current_alley.frames.find_by(current: true)

            if current_frame.can_hit?(pins)
                Throw.create(frame_id: current_frame.id, alley_id: current_alley.id, pins: pins)
                if current_frame.number != 10
                    if current_frame.pins + pins == 10
                        res = current_frame.throws.count == 1 ? 'X' : "#{current_frame.throws.first.pins}/#{current_frame.throws.last.pins}"
                        current_alley.complete(current_frame.number, res, 10)
                    elsif current_frame.throws.count == 2
                        current_alley.complete(current_frame.number, "S#{current_frame.pins + pins}", current_frame.pins + pins)
                    else
                        current_frame.update(pins: pins, result: pins)
                    end
                else
                    res = pins == 10 ? 'X' : pins
                    if current_frame.throws.count == 1
                        current_frame.update(pins: pins, result: res)
                    elsif current_frame.throws.count == 2
                        if current_frame.throws.first.pins != 10
                            current_frame.pins + pins != 10 ? current_alley.complete(current_frame.number, "S#{current_frame.pins + pins}", current_frame.pins + pins) : current_frame.update(pins: current_frame.pins + pins, result: "S#{current_frame.pins + pins}")
                        else
                            current_frame.update!(pins: current_frame.pins + pins, result: "#{current_frame.result} #{res}")
                        end
                    else
                        current_frame.result == 'X X' || current_frame.throws.first.pins != 10 ? current_alley.complete(current_frame.number, "#{current_frame.result} #{res}", current_frame.pins + pins) : current_alley.complete(current_frame.number, "#{current_frame.result}/#{pins}", current_frame.pins + pins)
                    end
                end
                current_alley.check_points
            end
        end
    end
end
