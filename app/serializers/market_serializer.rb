class MarketSerializer
  def self.format_markets(markets)
    markets.map do |market|
      {
        id: market.id,
        name: market.name,
        state: market.state,
        vendor_count: market.vendors.count,
        lat: market.lat,
        lon: market.lon,
        county: market.county,
        street: market.street,
        city: market.city,
        zip: market.zip
      }
    end
  end
end
