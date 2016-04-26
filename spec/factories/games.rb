FactoryGirl.define do
    factory :game do
        before(:create) do |game|
            game.alleys << FactoryGirl.build(:alley, game: game)
        end
    end
end
