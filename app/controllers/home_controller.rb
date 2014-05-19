class HomeController < ApplicationController
  def index
    @stops = [
      {
        address: "41-23 24th Street, Long Island City, NY 11101, USA",
        addressLatLng: {
          'A' => -73.94012199999997,
          k: 40.75176099999999
        },
        origin: true
      },
      {
        address: "40 Fulton Street, New York, NY 10038, USA",
        addressLatLng: {
          'A' => -74.00473099999999,
          k: 40.70787199999999
        },
      },
      {
        address: "20 Jay Street, Brooklyn, NY 11201, USA",
        addressLatLng: {
          'A' => -73.986759,
          k: 40.7040072
        },
        destination: true
      }
    ].to_json
  end
end
