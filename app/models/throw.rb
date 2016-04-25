class Throw < ActiveRecord::Base
    belongs_to :frame

    validates :frame_id, :pins, presence: true
    validates :pins, inclusion: { in: (0..10) }
end
