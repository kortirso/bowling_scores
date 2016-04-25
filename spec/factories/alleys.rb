FactoryGirl.define do
    factory :alley do
        association :game
        sequence(:player) { |i| "player#{i}" }
        points 0
    end
end
