# frozen_string_literal: true
class Vendor < ApplicationRecord
  validates :name,
            :description,
            :contact_name,
            :contact_phone,
            :credit_accepted,
            presence: true

  has_many :market_vendors
  has_many :markets, through: :market_vendors
end
