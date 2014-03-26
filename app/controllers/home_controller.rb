class HomeController < ApplicationController
  def verifyWaypoint
    gmap_string = 'https://maps.googleapis.com/maps/api/geocode/json?&sensor=false'
    gmap_string += "&address=#{params[:location]}"
    resp = makeGoogleCall(gmap_string)

    found_hash = {
      found: resp['results'][0]['types'][0] == 'street_address',
      address: resp['results'][0]['formatted_address'],
      lat_long: "#{resp['results'][0]['geometry']['location']['lat']}, #{resp['results'][0]['geometry']['location']['lng']}"
    }

    render json: found_hash
  end

  def getShares
    dest = params[:waypoints].last
    legs = params[:waypoints].reject{ |waypoint| waypoint == dest}.join('|')

    gmap_string = 'https://maps.googleapis.com/maps/api/directions/json?&sensor=false'
    gmap_string += "&origin=#{params[:origin]}"
    gmap_string += "&waypoints=#{legs}" if legs.present?
    gmap_string += "&destination=#{dest}"
    gmap_string += "&key=#{@key}"

    resp = makeGoogleCall( gmap_string )
    legs = []
    total_distance = 0

    resp['routes'][0]['legs'].each do |leg|
      leg_distance = leg['distance']['value']
      total_distance += leg_distance

      legs << { distance: leg_distance, miles: leg['distance']['text'] }
    end

    legs.each do |leg|
      leg[:percent] = leg[:distance] / total_distance.to_f
      leg[:share] = (params[:fare].to_f * leg[:percent]).round(2)

      leg[:percent] = (100 * leg[:percent]).round(2)
    end

    render json: legs
  end

  private

  def makeGoogleCall(gmap_string)
    gmap_string += "&key=AIzaSyDupZ5WuFO8u8vRuDscjT-dQd2ju_YbwEQ"
    puts URI::encode(gmap_string)
    HTTParty.get( URI::encode(gmap_string) )
  end
end
