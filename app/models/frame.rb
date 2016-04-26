class Frame < ActiveRecord::Base
    belongs_to :alley
    has_many :throws

    validates :alley_id, :number, :pins, presence: true
    validates :number, inclusion: { in: (1..10) }

    scope :with_number, -> (number) { find_by(number: number) }

    def can_hit?(pins)
        if self.number != 10
            result = self.throws.count == 0 || 10 - self.pins >= pins ? true : false
        else
            result = self.throws.count == 0 || (self.throws.count == 1 && self.throws.first.pins == 10) || (self.throws.count == 1 && 10 - self.pins >= pins) || (self.throws.count == 2 && self.result == 'X X') || (self.throws.count == 2 && self.throws.first.pins != 10) || (self.throws.count == 2 && self.throws.last.pins != 10 && 10 - self.throws.last.pins >= pins) ? true : false
        end
        result
    end
end
