RSpec.describe ThrowController, type: :controller do
    describe 'POST #create' do
        let!(:game) { create :game }

        it 'saves the new throw in the DB' do
            expect { post :create, throw: { game: game.id, pins: 1 }, format: :js }.to change(Throw, :count).by(1)
        end

        it 'redirects to show view' do
            post :create, throw: { game: game.id, pins: 1 }, format: :js

            expect(response).to render_template :create
        end
    end
end
