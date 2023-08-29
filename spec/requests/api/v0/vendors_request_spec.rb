# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Vendors', type: :request do
  context 'GET /show' do
    before :each do
      create(:market, id: 1)
      vendor = create(:vendor, id: 1, credit_accepted: true)
      create(:market_vendor, market_id: 1, vendor_id: 1)

      get "/api/v0/vendors/#{vendor.id}"
    end
    scenario 'displays a single vendor and attributes' do
      vendors = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(vendors[:data]).to have_key(:id)
      expect(vendors[:data][:id]).to be_an(String)

      expect(vendors[:data][:attributes]).to have_key(:name)
      expect(vendors[:data][:attributes][:name]).to be_a(String)

      expect(vendors[:data][:attributes]).to have_key(:description)
      expect(vendors[:data][:attributes][:description]).to be_a(String)

      expect(vendors[:data][:attributes]).to have_key(:contact_name)
      expect(vendors[:data][:attributes][:contact_name]).to be_a(String)

      expect(vendors[:data][:attributes]).to have_key(:contact_phone)
      expect(vendors[:data][:attributes][:contact_phone]).to be_a(String)

      expect(vendors[:data][:attributes]).to have_key(:credit_accepted)
      expect(vendors[:data][:attributes][:credit_accepted]).to be_truthy.or be_falsey
    end
  end

  context 'happy path and sad path for GET/show' do
    scenario 'happy path, returns code 200' do
      create(:market, id: 1)
      vendor = create(:vendor, id: 1, credit_accepted: true)
      create(:market_vendor, market_id: 1, vendor_id: 1)

      get "/api/v0/vendors/#{vendor.id}"

      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    scenario 'sad path, returns code 404' do
      get '/api/v0/vendors/123123123123'

      error_response = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(response.status).to eq(404)
      expect(error_response['errors']).to eq("Couldn't find Vendor with 'id'=123123123123")
    end
  end
end
