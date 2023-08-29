class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all
    render json: MarketSerializer.new(markets)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  rescue ActiveRecord::RecordNotFound
    render_market_not_found
  end

  def vendors
    render json: VendorSerializer.new(Market.find(params[:id]).vendors)
  rescue ActiveRecord::RecordNotFound
    render_market_not_found
  end

  private

  def render_market_not_found
    render json: ErrorMarket.new("Couldn't find Market with 'id'=#{params[:id]}").errors, status: :not_found
  end
end
