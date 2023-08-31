# frozen_string_literal: true
class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  # validate :validate_market_vendor_ids, on: :create

  # def validate_market_vendor_ids
  #   if MarketVendor.find_by(market_id: market.id, vendor_id: vendor.id)
  #     errors.add(:market_vendor, "Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
  #   end
  # end
end
