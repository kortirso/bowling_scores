FactoryGirl.define do
    factory :game do
        before(:create) do |game|
            3.times { game.alleys << build(:alley, game: game) }
        end
    end
end
