class GamesController < ApplicationController
    before_action :find_game, only: :show

    def index
        @games = Game.all
    end

    def show
        
    end

    def new
        @game = Game.new
    end

    def create
        @game = Game.create(game_params)
        redirect_to @game
    end

    private
    def game_params
        params.require(:game).permit(alleys_attributes: [:player])
    end

    def find_game
        @game = Game.find(params[:id])
    end
end
