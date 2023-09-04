class AtmFacade
  def self.nearest_atms(params)
    NearestAtmService.get_nearest_atm(params)
  end
end
