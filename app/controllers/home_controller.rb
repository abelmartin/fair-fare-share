class HomeController < ApplicationController
  def index
    @stopsZZZ = [
      {address: '3064 34th st, astoria, NY 11103, USA', origin: true},
      {address: '40 Fulton Street, New York, NY 10038, USA'},
      {address: '50 Jay Street, Brooklyn, NY 11201, USA'},
      {address: '30 W 26th St, ny ny', destination: true}
    ].to_json
  end
end
