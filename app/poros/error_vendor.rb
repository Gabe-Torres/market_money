class ErrorVendor
  attr_reader :errors

  def initialize(detail)
    @errors = detail
  end
end
