class Alley < ActiveRecord::Base
    belongs_to :game
    has_many :frames

    validates :player, :points, presence: true

    after_create :create_frames

    private
    def create_frames
        (1..10).each { |row| self.frames.create(number: row) }
    end
end
