RSpec.describe Throw, type: :model do
    it { should belong_to :frame }
    it { should validate_presence_of :frame_id }
    it { should validate_presence_of :pins }
    it { should validate_inclusion_of(:pins).in_range(0..10) }
end
