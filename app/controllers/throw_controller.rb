class ThrowController < ApplicationController
    before_action :set_variables, only: :create

    def create
        Throw.build(params[:throw][:game], params[:throw][:pins].to_i)
    end

    private
    def set_variables
        @game = Game.find(params[:throw][:game])
        @current_alley = @game.alleys.find_by(current_throw: true)
        @current_frame = @current_alley.frames.find_by(current: true)
    end
end
