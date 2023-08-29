# frozen_string_literal: true
FactoryBot.define do
  factory :vendor do
    name { Faker::JapaneseMedia::Naruto.character }
    description { Faker::JapaneseMedia::StudioGhibli.quote }
    contact_name { Faker::Ancient.hero }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end
