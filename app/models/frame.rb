class Frame < ActiveRecord::Base
    belongs_to :alley
    has_many :throws

    validates :alley_id, :number, :pins, presence: true
    validates :number, inclusion: { in: (1..10) }
    validates :pins, inclusion: { in: (0..10) }
end
