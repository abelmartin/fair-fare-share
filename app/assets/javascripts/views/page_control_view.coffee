@FFS ?=  {}
@FFS.Views ?=  {}

@FFS.Views.PageControlView = Backbone.View.extend
  el: '#buttons'

  events:
    'click #addWaypoint': 'addWaypoint'
    'click #calculateShares': 'calculateShares'
    'click #viewWaypoints': 'viewWaypoints'
    'click #viewMap': 'viewMap'

  initialize: (options) ->
    @geocoder = options.googleServices.geocoder
    @directionsService = options.googleServices.directionsService

  addWaypoint: ->
    new window.FFS.Views.WaypointView
      geocoder: @geocoder

  calculateShares: ->
    totalKM = 0
    fareFare = $('#finalFare').val()
    origin = window.FFS.objs.waypoints.find (waypoint) ->
      waypoint.get('origin') == true && waypoint.get('addressLatLng')?

    unless origin?
      window.FFS.objs.toaster.model.set({message: 'You must set a starting location'})
      return null

    dest = waypoints.last()

    midpoints = waypoints.reject (rpoint) -> rpoint.get('origin') || rpoint.get('destination')
    legs = midpoints.map (mpoint) -> { location: mpoint.get('addressLatLng'), stopover: true }

    if midpoints.length == 0
      window.FFS.objs.toaster.model.set({message: 'Please Choose 2 Or More Cab Stops'})
      return null

    dirParams =
      origin: origin.get('addressLatLng')
      destination: dest.get('addressLatLng')
      waypoints: legs
      optimizeWaypoints: false
      travelMode: google.maps.TravelMode.DRIVING

    @directionsService.route dirParams, (resp, status) ->
      totalKM = _.reduce resp.routes[0].legs, ((memo, leg) -> memo + leg.distance.value), 0

      _.each resp.routes[0].legs, (leg, idx) ->
        point = waypoints.models[idx+1]
        prcnt = Math.round((leg.distance.value * 1.0 / totalKM) * 100)
        point.set
          mileage: leg.distance.text
          percentage: prcnt
          fareShare: Math.round(fareFare * (prcnt / 100) * 100) / 100

      waypoints.trigger('sharesCalculated')
