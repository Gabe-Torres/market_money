class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :state, :vendor_count, :lat, :lon, :county, :street, :city, :zip
  has_many :vendors

  attribute :vendor_count do |object|
    object.vendors.count
  end
  # def self.format_markets(markets)
  #   markets.map do |market|
  #     { "data": [
  #       {

  #         id: market.id,
  #       # type: market.type,
  #         attributes: {
  #           name: market.name,
  #           state: market.state,
  #           vendor_count: market.vendors.count,
  #           lat: market.lat,
  #           lon: market.lon,
  #           county: market.county,
  #           street: market.street,
  #           city: market.city,
  #           zip: market.zip
  #         }
  #       }
  #     ] }
    # end
  # end
end
