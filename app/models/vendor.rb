# frozen_string_literal: true
class Vendor < ApplicationRecord
  validates :name,
            :description,
            :contact_name,
            :contact_phone,
            presence: true

  validates :credit_accepted, inclusion: [true, false]

  has_many :market_vendors, dependent: :destroy
  has_many :markets, through: :market_vendors

  # def valid_credit_accepted
  #   return if credit_accepted.nil?

  #   errors.add(:credit_accepted, 'must be true or false') unless [true, false].include?(credit_accepted)
  # end
end
