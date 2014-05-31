@FFS ?=  {}
@FFS.Collections ?=  {}

#By instantiating the directionsService here, it gets closed over and
#behaves a little like a singleton :-)
directionsService = new google.maps.DirectionsService()

#Extracting this method out allows us to test correctly.
callDirectionsService = (origin, destination, legs) ->
  dirParams =
    origin: origin.get('addressLatLng')
    destination: destination.get('addressLatLng')
    waypoints: legs
    optimizeWaypoints: false
    travelMode: google.maps.TravelMode.DRIVING

  directionsService.route dirParams, (resp, status) =>
    @_processResponse.apply(@, [resp, status])

@FFS.Collections.Waypoints = Backbone.Collection.extend
  model: window.FFS.Models.Waypoint
  totalFare: 0

  _processResponse: (resp, status) ->
    totalKM = _.reduce resp.routes[0].legs, ((memo, leg) -> memo + leg.distance.value), 0
    running_total = 0

    fareHolder = []
    _.each resp.routes[0].legs, (leg, idx) =>
      wpointIdx = idx+1
      point = @models[wpointIdx]
      occupancy = @length - wpointIdx


      prcnt = Math.round((leg.distance.value * 1.0 / totalKM) * 100)
      stop_cost = Math.round(@totalFare * (prcnt / 100) * 100) / 100

      running_total += (stop_cost / occupancy)

      point.set
        mileage: leg.distance.text
        percentage: prcnt
        fareShare: running_total
        fareShareString: running_total.toFixed(2)

    @trigger('sharesCalculated')

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
    @totalFare = totalFare
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

    callDirectionsService.apply(@, [origin, destination, legs])
