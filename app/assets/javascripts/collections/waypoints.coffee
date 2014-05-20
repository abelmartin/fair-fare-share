@FFS ?=  {}
@FFS.Collections ?=  {}

directionsService = new google.maps.DirectionsService()

callDirectionsService = (totalFare, origin, destination, legs) ->
  dirParams =
    origin: origin.get('addressLatLng')
    destination: destination.get('addressLatLng')
    waypoints: legs
    optimizeWaypoints: false
    travelMode: google.maps.TravelMode.DRIVING

  processResponse = (resp, status) =>
    totalKM = _.reduce resp.routes[0].legs, ((memo, leg) -> memo + leg.distance.value), 0

    _.each resp.routes[0].legs, (leg, idx) =>
      point = @models[idx+1]
      prcnt = Math.round((leg.distance.value * 1.0 / totalKM) * 100)
      point.set
        mileage: leg.distance.text
        percentage: prcnt
        fareShare: Math.round(totalFare * (prcnt / 100) * 100) / 100

    @trigger('sharesCalculated')

  directionsService.route dirParams, processResponse

@FFS.Collections.Waypoints = Backbone.Collection.extend
  model: window.FFS.Models.Waypoint

  initialize: ->
    @on 'add', (waypoint) ->
      @each (point) -> point.set({destination: false}, {silent: true})
      waypoint.set({destination: true}, {silent: true})

    @on 'remove', (waypoint) ->
      @each (point) => point.set({destination: false}, {silent: true})
      lastPoint = @last()
      lastPoint.set({destination: true}, {silent: true}) unless lastPoint.get('origin')

  calculateShares: (totalFare) ->
    totalKM = 0
    origin = @find (waypoint) ->
      waypoint.get('origin') == true && waypoint.get('addressLatLng')?

    unless origin?
      window.FFS.showToaster 'You must set a starting location'
      return null

    destination = @last()

    midpoints = @reject (rpoint) -> rpoint.get('origin') || rpoint.get('destination')
    legs = midpoints.map (mpoint) -> { location: mpoint.get('addressLatLng'), stopover: true }

    if midpoints.length == 0
      window.FFS.showToaster 'Please Choose 2 Or More Cab Stops'
      return null

    callDirectionsService.apply(@, [totalFare, origin, destination, legs])
