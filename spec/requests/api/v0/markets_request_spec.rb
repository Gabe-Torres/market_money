# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Markets', type: :request do
  context 'GET /index' do
    before :each do
      create_list(:market, 3)

      get '/api/v0/markets'
    end
    it 'returns a list of all markets data' do
      markets = JSON.parse(response.body, symbolize_names: true)

      markets.each do |m|
        expect(m).to have_key(:id)
        expect(m[:id]).to be_an(Integer)

        expect(m).to have_key(:state)
        expect(m[:state]).to be_a(String)

        expect(m).to have_key(:county)
        expect(m[:county]).to be_a(String)

        expect(m).to have_key(:city)
        expect(m[:city]).to be_a(String)

        expect(m).to have_key(:zip)
        expect(m[:zip]).to be_a(String)

        expect(m).to have_key(:street)
        expect(m[:street]).to be_a(String)

        expect(m).to have_key(:lat)
        expect(m[:lat]).to be_a(String)

        expect(m).to have_key(:lon)
        expect(m[:lon]).to be_a(String)

        expect(m).to have_key(:name)
        expect(m[:name]).to be_a(String)

        expect(m).to have_key(:vendor_count)
        expect(m[:vendor_count]).to be_an(Integer)
      end
    end
  end

  context 'happy path and sad path' do
    scenario 'happy path, returns code 200' do
      get '/api/v0/markets'

      expect(response).to have_http_status(:success)
    end
    scenario 'sad path' do
      create_list(:market, 3)

      get '/api/v0/markets', params: { id: '' }
      markets = JSON.parse(response.body, symbolize_names: true)

      markets.each do |m|
        expect(m).to have_key(:vendor_count)
        expect(m[:vendor_count]).to eq(0)
      end
    end
  end
end
