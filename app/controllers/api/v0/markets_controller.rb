class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all
    # render json: MarketSerializer.format_markets(markets)
    render json: MarketSerializer.new(markets)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  rescue ActiveRecord::RecordNotFound
    render json: ErrorMarket.new("Couldn't find Market with 'id'=#{params[:id]}").errors, status: :not_found
  end
end
