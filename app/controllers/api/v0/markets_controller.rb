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

  def search
    market_search_params = params.permit(:state, :city, :name)
    market_search = MarketSearchService.new
    if market_search.invalid_combo(market_search_params)
      render json: { error: "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint." }, status: :unprocessable_entity
    else
      render json: MarketSerializer.new(market_search.filter(market_search_params))
    end
  end

  private

  def search_params
    params.permit(:state, :city, :name)
  end

  def render_market_not_found
    render json: ErrorMarket.new("Couldn't find Market with 'id'=#{params[:id]}"), status: :not_found
  end
end
