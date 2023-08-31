class Api::V0::MarketVendorsController < ApplicationController
  def create
    market = Market.find_by(id: market_vendor_params[:market_id])
    vendor = Vendor.find_by(id: market_vendor_params[:vendor_id])

    if market.nil?
      render json: ErrorMarketVendor.new("Validation failed: Market must exist"), status: :not_found
    elsif market_vendor_params[:vendor_id].blank?
      render json: ErrorMarketVendor.new("Validation failed: Vendor must exist"), status: :bad_request
    elsif vendor.nil?
      render json: ErrorMarketVendor.new("Validation failed: Vendor must exist"), status: :not_found
    elsif market_vendor_params[:market_id].blank?
      render json: ErrorMarketVendor.new("Validation failed: Market must exist"), status: :bad_request
    elsif MarketVendor.find_by(market_id: market.id, vendor_id: vendor.id)
      render json: ErrorMarketVendor.new("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists"), status: :unprocessable_entity
    else
      render json: MarketVendorSerializer.new(MarketVendor.create!(market_vendor_params)), status: :created
    end
  end

  private

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end
end
