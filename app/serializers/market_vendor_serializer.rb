class MarketVendorSerializer
  include JSONAPI::Serializer
  attributes :id, :market_id, :vendor_id
end
