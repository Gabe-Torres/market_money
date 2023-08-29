# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Markets', type: :request do
  context 'GET /index' do
    before :each do
      create(:market, id: 1)
      create(:market, id: 2)
      create(:market, id: 3)
      create(:vendor, id: 1, credit_accepted: true)
      create(:vendor, id: 2, credit_accepted: true)
      create(:vendor, id: 3, credit_accepted: true)
      create(:market_vendor, market_id: 1, vendor_id: 1)
      create(:market_vendor, market_id: 3, vendor_id: 3)

      get '/api/v0/markets'
    end
    it 'returns a list of all markets data' do
      markets = JSON.parse(response.body, symbolize_names: true)
      markets[:data].each do |m|
        expect(m).to have_key(:id)
        expect(m[:id]).to be_an(String)

        expect(m[:attributes]).to have_key(:state)
        expect(m[:attributes][:state]).to be_a(String)

        expect(m[:attributes]).to have_key(:county)
        expect(m[:attributes][:county]).to be_a(String)

        expect(m[:attributes]).to have_key(:city)
        expect(m[:attributes][:city]).to be_a(String)

        expect(m[:attributes]).to have_key(:zip)
        expect(m[:attributes][:zip]).to be_a(String)

        expect(m[:attributes]).to have_key(:street)
        expect(m[:attributes][:street]).to be_a(String)

        expect(m[:attributes]).to have_key(:lat)
        expect(m[:attributes][:lat]).to be_a(String)

        expect(m[:attributes]).to have_key(:lon)
        expect(m[:attributes][:lon]).to be_a(String)

        expect(m[:attributes]).to have_key(:name)
        expect(m[:attributes][:name]).to be_a(String)

        expect(m[:attributes]).to have_key(:vendor_count)
        expect(m[:attributes][:vendor_count]).to be_an(Integer)
      end
    end
  end

  context 'happy path and sad path' do
    scenario 'happy path, returns code 200' do
      get '/api/v0/markets'

      expect(response).to have_http_status(:success)
    end
    # scenario 'sad path' do
    #   create(:market, id: 1)
    #   create(:vendor, id: 1, credit_accepted: true)
    #   create(:market_vendor, market_id: 1, vendor_id: 1)

    #   get '/api/v0/markets', params: { name: '' }
    #   markets = JSON.parse(response.body, symbolize_names: true)

    #   markets[:data].each do |m|
    #     expect(m[:attributes]).to have_key(:vendor_count)
    #     expect(m[:attributes][:vendor_count]).to eq(0)
    #   end
    # end
  end
end
