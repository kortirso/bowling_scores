RSpec.describe GamesController, type: :controller do
    describe 'GET #index' do
        let!(:games) { create_list(:game, 2) }
        before { get :index }

        it 'assigns all games to @games' do
            expect(assigns(:games)).to eq Game.all
        end

        it 'and render index view' do
            expect(response).to render_template :index
        end
    end

    describe 'GET #show' do
        let!(:game) { create :game }
        before { get :show, id: game.id }

        it 'assigns the requested game to @game' do
            expect(assigns(:game)).to eq game
        end

        it 'and render show view' do
            expect(response).to render_template :show
        end
    end

    describe 'GET #new' do
        before { get :new }

        it 'assigns a new game to @game' do
            expect(assigns(:game)).to be_a_new(Game)
        end

        it 'renders new view' do
            expect(response).to render_template :new
        end
    end

    describe 'POST #create' do
        it 'saves the new game in the DB' do
            expect { post :create, game: { alleys_attributes: { "0" => { player: "First" }, "1" => { player:"Second" } } } }.to change(Game, :count).by(1)
        end

        it 'redirects to show view' do
            post :create, game: { alleys_attributes: { "0" => { player: "First" }, "1" => { player:"Second" } } }

            expect(response).to redirect_to game_path(assigns(:game))
        end
    end
end
