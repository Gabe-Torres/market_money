class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :state, :vendor_count, :lat, :lon, :county, :street, :city, :zip
  has_many :vendors

  attribute :vendor_count do |object|
    object.vendors.count
  end
end
