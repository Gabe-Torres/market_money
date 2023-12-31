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
      expect { Vendor.find(123123123123) }.to raise_error { ActiveRecord::RecordNotFound }
    end
  end

  context 'GET /create' do
    scenario 'creates a new vendor and passes all attributes' do
      vendor_params = ({
                        name: 'Charizard Farms',
                        description: 'firey',
                        contact_name: 'Ash Ketchum',
                        contact_phone: '123-456-7890',
                        credit_accepted: true
                      })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)

      created_vendor = Vendor.last

      expect(response).to be_successful
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end
  end

  context 'happy path and sad path for POST/create' do
    scenario 'happy path, returns code 201' do
      vendor_params = ({
                        'name': 'Buzzy Bees',
                        'description': 'local honey and wax products',
                        'contact_name': 'Berly Couwer',
                        'contact_phone': '8389928383',
                        'credit_accepted': false
                      })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to have_http_status(:created)
      expect(response.status).to eq(201)
    end

    scenario 'sad path, returns code 400' do
      vendor_params = ({
                        'name': "Buzzy Bees",
                        'description': "local honey and wax products",
                        'credit_accepted': false
                      })

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v0/vendors', headers: headers, params: JSON.generate(vendor: vendor_params)
      error_response = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(response.status).to eq(400)
      expect(error_response['errors']).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
    end
  end

  context 'PATCH /update' do
    scenario 'updates a vendor and passes all attributes' do
      id = create(:vendor).id
      previous_name = Vendor.last.name
      vendor_params = {
                        'name': 'Kimberly Couwer',
                        'contact_phone': '8389928384'
                      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)

      vendor = Vendor.find_by(id: id)

      expect(response).to be_successful
      expect(vendor.name).to_not eq(previous_name)
      expect(vendor.name).to eq('Kimberly Couwer')
    end
  end

  context 'happy and sad path for PATCH /update' do
    scenario 'happy path, returns code 200' do
      id = create(:vendor).id
      vendor_params = ({
                        'name': 'Kimberly Couwer',
                        'contact_phone': '8389928384'
                      })
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)
      expect(response).to have_http_status(:success)
      expect(response.status).to eq(200)
    end

    scenario 'sad path, returns code 400' do
      id = create(:vendor).id
      vendor_params = ({
                        'name': '',
                        'description': ''
                      })
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor: vendor_params)
      error_response = JSON.parse(response.body)
      expect(response).to have_http_status(:bad_request)
      expect(response.status).to eq(400)
      expect(error_response['errors']).to eq("Validation failed: Name can't be blank, Description can't be blank")
    end
  end

  context 'DELETE /destroy' do
    scenario 'deletes a vendor and assoications' do
      vendor = create(:vendor)
      market = create(:market, id: 1)
      create(:market_vendor, market: market, vendor: vendor)

      expect(Vendor.count).to eq(1)
      expect(MarketVendor.count).to eq(1)

      expect { delete "/api/v0/vendors/#{vendor.id}" }.to change(Vendor, :count).by(-1)
      expect(response).to be_successful
      expect(MarketVendor.count).to eq(0)
      expect { Vendor.find(vendor.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'happy and sad path for DELETE /destroy' do
    scenario 'happy path, returns code 204' do
      vendor = create(:vendor)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to have_http_status(:no_content)
      expect(response.status).to eq(204)
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
