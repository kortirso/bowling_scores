class Game < ActiveRecord::Base
    has_many :alleys, dependent: :destroy
    accepts_nested_attributes_for :alleys, allow_destroy: true

    after_create :set_throw

    private
    def set_throw
        self.alleys.order(id: :asc).first.update(current_throw: true)
    end
end
