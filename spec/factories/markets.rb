# frozen_string_literal: true
FactoryBot.define do
  factory :market do
    name { Faker::Games::ElderScrolls.name }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Games::ElderScrolls.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end
