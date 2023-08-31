require 'rails_helper'

RSpec.describe 'MarketVendors', type: :request do
  context 'POST /create' do
    scenario 'creates a new market_vendor and associates market and vendor' do
      market = create(:market, id: 1)
      vendor = create(:vendor, id: 1, credit_accepted: true)

      market_vendor_params = ({ market_id: market.id, vendor_id: vendor.id })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

      created_market_vendor = MarketVendor.last

      expect(response).to be_successful
      expect(created_market_vendor.market_id).to eq(market.id)
      expect(created_market_vendor.vendor_id).to eq(vendor.id)
    end
  end

  context 'happy and sad path for POST /create' do
    scenario 'happy path, returns code 201' do
      market = create(:market, id: 322474)
      vendor = create(:vendor, id: 54861, credit_accepted: true)

      market_vendor_params = ({ market_id: market.id, vendor_id: vendor.id })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)
      # success_response = JSON.parse(response.body)
      expect(response).to have_http_status(:created)
      expect(response.status).to eq(201)
      expect { Market.find(market.id) }.to_not raise_error
      # expect(success_response['message']).to eq('Successfully added vendor to market')
    end

    scenario 'sad path, returns code 404 for Market' do
      vendor = create(:vendor, id: 54861, credit_accepted: true)

      market_vendor_params = ({ market_id: 987654321, vendor_id: vendor.id })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

      error_response = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(response.status).to eq(404)
      expect { Market.find(987654321) }.to raise_error { ActiveRecord::RecordNotFound }
    end

    scenario 'sad path, returns code 400 for Vendor' do
      market = create(:market, id: 322474)

      market_vendor_params = ({ market_id: market.id, vendor_id: '' })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

      error_response = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(response.status).to eq(400)
      expect { Vendor.find('') }.to raise_error { ActiveRecord::RecordNotFound }
    end

    scenario 'sad path, returns code 422 for duplicate' do
      market = create(:market, id: 322474)
      vendor = create(:vendor, id: 54861, credit_accepted: true)
      create(:market_vendor, market_id: market.id, vendor_id: vendor.id)
      market_vendor_params = ({ market_id: market.id, vendor_id: vendor.id })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor_params)

      error_response = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.status).to eq(422)
      expect(error_response['errors']).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end
  end

  context 'DELETE /destroy' do
    scenario 'deletes a market_vendor and any associations' do
      vendor = create(:vendor)
      market = create(:market, id: 1)
      create(:market_vendor, market: market, vendor: vendor)

      expect(Vendor.count).to eq(1)
      expect(Market.count).to eq(1)
      expect(MarketVendor.count).to eq(1)

      request_body = ({ market_id: market.id, vendor_id: vendor.id })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(request_body)

      expect(response).to have_http_status(:no_content)
      expect(MarketVendor.count).to eq(0)
      expect(Vendor.count).to eq(0)
      expect(Market.count).to eq(0)
      expect { MarketVendor.find(vendor.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'happy and sad path for DELETE /destroy' do
    scenario 'happy path, returns code 204' do
      vendor = create(:vendor, id: 54861)
      market = create(:market, id: 322474)
      create(:market_vendor, market: market, vendor: vendor)

      request_body = ({ market_id: market.id, vendor_id: vendor.id })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      expect { delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(request_body) }.to change(MarketVendor, :count).by(-1)
      expect { MarketVendor.find(market.id) }.to raise_error { ActiveRecord::RecordNotFound }
      expect { MarketVendor.find(vendor.id) }.to raise_error { ActiveRecord::RecordNotFound }
      expect(response).to have_http_status(:no_content)
      expect(response.status).to eq(204)
    end

    scenario 'sad path, returns code 404' do
      market = create(:market, id: 4233)
      vendor = create(:vendor, id: 11520)
      request_body = ({ market_id: 4233, vendor_id: 11520 })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(request_body)

      error_response = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(response.status).to eq(404)
      expect(error_response['errors']).to eq("No MarketVendor with market_id=#{market.id} AND vendor_id=#{vendor.id} exist")
    end
  end
end
