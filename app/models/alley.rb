class Alley < ActiveRecord::Base
    belongs_to :game
    has_many :frames

    validates :player, :points, :game_id, presence: true
end
