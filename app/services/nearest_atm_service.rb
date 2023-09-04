class NearestAtmService
  def self.conn
    Faraday.new(url: 'https://api.tomtom.com') do |faraday|
      faraday.params['key'] = ENV['TOMTOM_API_KEY']
    end
  end

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_nearest_atm(market)
    data = get_url("/search/2/categorySearch/atm.json?&lat=#{market[:lat]}&lon=#{market[:lon]}")
    response(data)
  end

  def self.response(data)
    data[:results].map do |atm_data|
      {
        "id": nil,
        "type": "atm",
        "attributes": {
          "name": "ATM",
          "address": atm_data[:address][:freeformAddress],
          "lat": atm_data[:position][:lat],
          "lon": atm_data[:position][:lon],
          "distance": atm_data[:dist]
        }
      }
    end.uniq
  end
end
# curl 'https://api.tomtom.com/search/2/categorySearch/atm.json?key={ven2airuQvgMn0eCA59seedc37TCgaAs}&lat={38.9169984}&lon={-77.0320505}'