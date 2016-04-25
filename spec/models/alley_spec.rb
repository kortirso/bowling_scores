RSpec.describe Alley, type: :model do
    it { should belong_to :game }
    it { should have_many :frames }
    it { should validate_presence_of :points }
    it { should validate_presence_of :player }
end