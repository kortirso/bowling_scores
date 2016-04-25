FactoryGirl.define do
    factory :frame do
        association :alley
        number 1
        pins 10
        result nil
    end
end
