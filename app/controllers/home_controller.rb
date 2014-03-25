class HomeController < ApplicationController
  def getShares
    dest = params[:waypoints].last
    legs = params[:waypoints].reject{ |waypoint| waypoint == dest}.join('|')

    gmap_string = 'https://maps.googleapis.com/maps/api/directions/json?&sensor=false'
    gmap_string += "&origin=#{params[:origin]}"
    gmap_string += "&waypoints=#{legs}" if legs.present?
    gmap_string += "&destination=#{dest}"

    puts URI::encode(gmap_string)
    resp = HTTParty.get( URI::encode(gmap_string) )
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
end
