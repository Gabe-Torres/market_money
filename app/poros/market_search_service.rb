class MarketSearchService
  def filter(market_search_params)
    filter_markets = Market.all
    filter_markets = filter_markets.where(state: market_search_params[:state]) if market_search_params[:state].present?
    filter_markets = filter_markets.where(city: market_search_params[:city]) if market_search_params[:city].present?
    filter_markets = filter_markets.where(name: market_search_params[:name]) if market_search_params[:name].present?

    filter_markets
  end

  def invalid_combo(market_search_params)
    city = market_search_params[:city].present?
    name = market_search_params[:name].present?
    state = market_search_params[:state].present?

    (city && !name && !state) || (city && name && !state)
  end
end
