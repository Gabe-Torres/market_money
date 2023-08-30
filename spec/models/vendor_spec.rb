require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
    # it { should validate_inclusion_of(:credit_accepted).in_array([true, false]) }
    # it 'validates credit_accepted' do
    #   vendor = Vendor.new(name: 'name', description: 'description', contact_name: 'contact_name', contact_phone: 'contact_phone', credit_accepted: 'credit_accepted')
    #   expect(vendor).to_not be_valid
    #   expect(vendor.errors[:credit_accepted]).to include("must be true or false")
    # end
  end

  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end
end
