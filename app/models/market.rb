# frozen_string_literal: true
class Market < ApplicationRecord
  validates :name,
            :street,
            :city,
            :county,
            :state,
            :zip,
            :lat,
            :lon,
            presence: true

  has_many :market_vendors
  has_many :vendors, through: :market_vendors
end
