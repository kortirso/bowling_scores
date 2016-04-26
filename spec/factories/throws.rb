FactoryGirl.define do
    factory :throw do
        association :frame
        association :alley
        pins 0
    end
end
