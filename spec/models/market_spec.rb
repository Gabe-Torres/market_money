require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
    # it { should_not validate_presence_of(:type) }
  end

  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end
end
