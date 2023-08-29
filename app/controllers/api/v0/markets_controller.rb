class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all
    # render json: MarketSerializer.format_markets(markets)
    render json: MarketSerializer.new(markets)
  end
end
