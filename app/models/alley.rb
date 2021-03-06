class Alley < ActiveRecord::Base
    belongs_to :game
    has_many :frames, dependent: :destroy
    has_many :throws, dependent: :destroy

    validates :player, :points, presence: true

    scope :current, -> { find_by(current_throw: true) }

    after_create :create_frames

    def complete(frame_number, res, pins)
        frames = self.frames
        current_frame = frames.with_number(frame_number)
        current_frame.update(result: res, pins: pins, current: false, completed: true)
        frames.with_number(current_frame.number + 1).update(current: true) if current_frame.number < 10
        self.change_alley
    end

    def check_points
        frames = self.frames
        frames.finished.each do |frame|
            points = frame.pins
            if frame.pins == 10
                first_next_throw = self.throws.where('id > ?', frame.throws.last.id).order(id: :asc).first
                if first_next_throw
                    second_next_throw = self.throws.where('id > ?', first_next_throw.id).order(id: :asc).first
                    points += first_next_throw.pins
                    points += second_next_throw.pins if frame.throws.count == 1 && second_next_throw
                end
            end
            frame.update(points: points)
        end
        self.update(points: self.frames.sum(:points))
    end

    def change_alley
        alleys = self.game.alleys.order(id: :asc)
        self.update(current_throw: false)
        if self.frames.finished.count == 10 && self == alleys.last
            self.game.update(completed: true)
        else
            self == alleys.last ? alleys.first.update(current_throw: true) : alleys.where('id > ?', self.id).order(id: :asc).first.update(current_throw: true)
        end
    end

    private
    def create_frames
        (1..10).each { |row| self.frames.create(number: row) }
        self.frames.with_number(1).update(current: true)
    end
end
