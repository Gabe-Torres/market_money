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
      expect(response).to be_successful

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

  context 'happy path and sad path for GET/index' do
    scenario 'happy path, returns code 200' do
      get '/api/v0/markets'
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
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

  context 'GET /show' do
    before :each do
      @id = create(:market, id: 1).id
      create(:vendor, id: 1, credit_accepted: true)
      create(:market_vendor, market_id: 1, vendor_id: 1)

      get "/api/v0/markets/#{@id}"
    end
    scenario 'searches for a market by id and displays attributes' do
      market = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(market[:data]).to have_key(:id)
      expect(market[:data][:id].to_i).to eq(@id)

      expect(market[:data][:attributes]).to have_key(:state)
      expect(market[:data][:attributes][:state]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:county)
      expect(market[:data][:attributes][:county]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:city)
      expect(market[:data][:attributes][:city]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:zip)
      expect(market[:data][:attributes][:zip]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:street)
      expect(market[:data][:attributes][:street]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:lat)
      expect(market[:data][:attributes][:lat]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:lon)
      expect(market[:data][:attributes][:lon]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:name)
      expect(market[:data][:attributes][:name]).to be_a(String)

      expect(market[:data][:attributes]).to have_key(:vendor_count)
      expect(market[:data][:attributes][:vendor_count]).to be_an(Integer)
    end
  end

  context 'happy path and sad path for GET/show' do
    scenario 'happy path, returns code 200' do
      id = create(:market, id: 1).id
      create(:vendor, id: 1, credit_accepted: true)
      create(:market_vendor, market_id: 1, vendor_id: 1)

      get "/api/v0/markets/#{id}"

      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    scenario 'sad path, returns code 404' do
      create(:market, id: 1)
      create(:vendor, id: 1, credit_accepted: true)
      create(:market_vendor, market_id: 1, vendor_id: 1)

      get '/api/v0/markets/123123123123'

      expect(response).to have_http_status(:not_found)
      expect(response.status).to eq(404)
      expect(response.body).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end
end
