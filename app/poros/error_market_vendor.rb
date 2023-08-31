class ErrorMarketVendor
  attr_reader :errors

  def initialize(detail)
    @errors = detail
  end
end