#Models should be responsible for communicating with the service model.

# Mustache styled underscore templtes!
_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};

### Classes ###
class GoogleServices
  constructor: ->
    @geocoder = new google.maps.Geocoder()
    @directionsService = new google.maps.DirectionsService()

ToasterView = Backbone.View.extend
  el: '#alert'

  initialize: (options) ->
    @model = new Backbone.Model({message: 'Please Choose 2 Or More Cab Stops'})
    @listenTo( @model, 'change:message', @render )

  render: ->
    @$el.html( @model.get('message') )

    @$el.show()
    setTimeout (=> @$el.fadeOut()), 3000

    return @

Waypoint = Backbone.Model.extend
  defaults:
    address: ''
    addressLatLng: null
    addressVerified: false
    fareShare: 'zzz'
    mileage: 'xxx'
    percentage: 'yyy'
    origin: false
    destination: false

  parse: (data) -> console.log @mileage

Waypoints = Backbone.Collection.extend
  model: Waypoint

  initialize: ->
    @on 'add', (waypoint) ->
      @each (point) -> point.set({destination: false}, {silent: true})
      waypoint.set({destination: true}, {silent: true})

    @on 'remove', (waypoint) ->
      @each (point) -> point.set({destination: false}, {silent: true})
      lastPoint = waypoints.last()
      lastPoint.set({destination: true}, {silent: true}) unless lastPoint.get('origin')


PageControlView = Backbone.View.extend
  el: '#buttons'

  events:
    'click #addWaypoint': 'addWaypoint'
    'click #calculateShares': 'calculateShares'

  initialize: (options)->
    @geocoder = options.googleServices.geocoder
    # @listentTo waypoints, 'add', @calculateShares
    # @listentTo waypoints, 'remove', @calculateShares

  addWaypoint: ->
    console.log '#addWaypoint'
    new WaypointView
      geocoder: @geocoder

  calculateShares: ->
    console.log '#calculateShares'
    totalKM = 0
    fareFare = $('#finalFare').val()
    origin = window.waypoints.find (waypoint) -> waypoint.get('origin') == true
    dest = window.waypoints.last()

    midpoints = waypoints.reject (rpoint) -> rpoint.get('origin') || rpoint.get('destination')
    legs = midpoints.map (mpoint) -> { location: mpoint.get('addressLatLng'), stopover: true }

    console.log 'legs =>'
    console.log legs

    dirParams =
      origin: origin.get('addressLatLng')
      destination: dest.get('addressLatLng')
      optimizeWaypoints: false
      travelMode: google.maps.TravelMode.DRIVING

    dirParams.waypoints = legs if legs.length > 0

    console.log 'dirParams =>'
    console.log dirParams

    gs.route dirParams, (resp, status) ->
      console.log resp
      totalKM = _.reduce resp.routes[0].legs, ((memo, leg) -> memo + leg.distance.value), 0

      _.each resp.routes[0].legs, (leg, idx) ->
        point = window.waypoints.models[idx+1]
        prcnt = Math.round((leg.distance.value * 1.0 / totalKM) * 100)
        point.set
          mileage: leg.distance.text
          percentage: prcnt
          fareShare: Math.round(fareFare * (prcnt / 100) * 100) / 100
        point.trigger('shareCalculated')


WaypointView = Backbone.View.extend
  className: 'waypoint'

  template: '#tmpWaypoint'

  events:
    'click .removeWaypoint': 'removeView'
    'click .getCurrentLocation': 'getCurrentLocation'
    'keydown .address' : 'keydownAddressUpdate'

  initialize: (options = {}) ->
    @$parent = if options.parent? then options.parent else $('#waypoints')

    @geocoder = options.geocoder
    @model = new Waypoint(options.modelAttrs)
    waypoints.add @model

    @listenTo(@model, 'change:address', @validateWaypoint)
    @listenTo(@model, 'change:addressLatLng', @validateWaypoint)
    @listenTo(@model, 'shareCalculated', @updateReport)
    @render()

  removeView: ->
    waypoints.remove(@model)
    @remove()

  updateReport: ->
    newReport = _.template "({{mileage}} miles, {{percentage}}%, ${{fareShare}})", @model.attributes
    $('.results', @$el).html( newReport )

  getCurrentLocation: ->
    console.log '#getCurrentLocation'

    geoOptions =
      enableHighAccuracy: false
      timeout: 5000
      maximumAge: 30000

    geoFail = (err) ->
      console.log err
      window.toaster.model.set {message: err.message}

    geoSucess = (coordResponse) =>
      console.log coordResponse
      @model.set
        addressLatLng: new google.maps.LatLng(coordResponse.coords.latitude, coordResponse.coords.longitude)

    navigator.geolocation.getCurrentPosition geoSucess, geoFail, geoOptions

  keydownAddressUpdate: (e) ->
    console.log '#blurAddressUpdate'
    if e.which == 13
      @model.set({address: $('.address', @$el).val()})

  validateWaypoint: ->
    console.log '#validateWaypoint'

    if @model.get('addressLatLng')? && @model.get('address') == ''
      geoParam = {location: @model.get('addressLatLng')}
    else
      geoParam = {address: @model.get('address')}

    @geocoder.geocode geoParam, (data, status) =>
      console.log data
      $('img.loader', @$el).show()

      foundLoc = _.find data, (result) ->
        result.types[0] == 'street_address'

      console.log foundLoc

      if foundLoc?
        latLng = foundLoc.geometry.location
        @model.set(
          {address: foundLoc.formatted_address, addressLatLng: latLng},
          {silent: true}
        )
      else
        toaster.model.set {message: "Address Not Found: #{@model.get('address')}"}

      $('.address', @$el).val(@model.get('address'))
      $('img.loader', @$el).hide()

      console.log @model.attributes

  render: ->
    if @model.get('origin')
      @$el.html('<label> Starting Location </label>')
    else
      @$el.html('<label> Cab Stop </label>')

    @$el.append(_.template($(@template).html(), @model.attributes))
    @$parent.append(@$el)

    unless navigator.geolocation
      @$el.find('.getCurrentLocation').addClass('off')

    return @

### INSTANCE VARIABLES ###
googleServices = new GoogleServices()
waypoints = new Waypoints()
@ffs = { waypoints: waypoints }

toaster = new ToasterView()
originView = new WaypointView
  parent: $('#origin')
  geocoder: googleServices.geocoder
  modelAttrs: {origin: true}
pageControlsView = new PageControlView
  el: '#buttons'
  googleServices: googleServices

### Everything's ready.  Let's show the form! ###
$('#loading').hide()
$('#ready').show()
