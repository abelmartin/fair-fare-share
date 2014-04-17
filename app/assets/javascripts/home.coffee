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
    @model = new Backbone.Model()
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


ReportView = Backbone.View.extend
  el: '#reports'

  initialize: (options) ->
    @listenTo waypoints, 'sharesCalculated', @render

  render: ->
    #clear what we have
    @$el.empty()
    newReports = []

    #Add the elements to an array while building them from template
    waypoints.each (wpoint) ->
      newReports.push _.template( "<div class='report'> ({{mileage}} miles, {{percentage}}%, ${{fareShare}}) </div>", wpoint.attributes )

    #A single insertion into the DOM is better than ittering the insertions
    @$el.html( newReports )

PageControlView = Backbone.View.extend
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
    new WaypointView
      geocoder: @geocoder

  calculateShares: ->
    totalKM = 0
    fareFare = $('#finalFare').val()
    origin = waypoints.find (waypoint) ->
      waypoint.get('origin') == true && waypoint.get('addressLatLng')?

    unless origin?
      toaster.model.set({message: 'You must set a starting location'})
      toaster.model.trigger('change:message')
      return null

    dest = waypoints.last()

    midpoints = waypoints.reject (rpoint) -> rpoint.get('origin') || rpoint.get('destination')
    legs = midpoints.map (mpoint) -> { location: mpoint.get('addressLatLng'), stopover: true }

    if midpoints.length == 0
      toaster.model.set({message: 'Please Choose 2 Or More Cab Stops'})
      toaster.model.trigger('change:message')
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
    @render()

  removeView: ->
    waypoints.remove(@model)
    @remove()

  getCurrentLocation: ->
    $button = $('.getCurrentLocation', @$el)
    $('img.loader', @$el).show()

    $button.prop('disabled', true)

    geoOptions =
      enableHighAccuracy: false
      timeout: 3000
      maximumAge: 30000

    geoFail = (err) =>
      $('img.loader', @$el).hide()
      toaster.model.set {message: err.message}
      toaster.model.trigger 'change:message'
      $button.prop('disabled', false)

    geoSucess = (coordResponse) =>
      $('img.loader', @$el).hide()
      @model.set
        addressLatLng: new google.maps.LatLng(coordResponse.coords.latitude, coordResponse.coords.longitude)
      $button.prop('disabled', false)

    navigator.geolocation.getCurrentPosition( geoSucess, geoFail, geoOptions )

  keydownAddressUpdate: (e) ->
    if e.which == 13
      @model.set({address: $('.address', @$el).val()})

  validateWaypoint: ->
    $('img.loader', @$el).show()

    if @model.get('addressLatLng')? && @model.get('address') == ''
      geoParam = {location: @model.get('addressLatLng')}
    else
      geoParam = {address: @model.get('address')}

    @geocoder.geocode geoParam, (data, status) =>
      $('img.loader', @$el).show()

      foundLoc = _.find data, (result) ->
        result.types[0] == 'street_address'

      if foundLoc?
        latLng = foundLoc.geometry.location
        @model.set(
          {address: foundLoc.formatted_address, addressLatLng: latLng},
          {silent: true}
        )
      else
        toaster.model.set {message: "Address Not Found: #{@model.get('address')}"}
        toaster.model.trigger 'change:message'


      $('.address', @$el).val(@model.get('address'))
      $('img.loader', @$el).hide()

  render: ->
    @$el.append(_.template($(@template).html(), @model.attributes))
    if @model.get('origin')
      $('.addressInputControlHeader', @$el).prepend('<label> Starting Location </label>')
    else
      $('.addressInputControlHeader', @$el).prepend('<label> Cab Stop </label>')
    @$parent.append(@$el)

    unless navigator.geolocation
      @$el.find('.getCurrentLocation').addClass('off')

    $('input.address', @$el).focus()
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
reportView = new ReportView()

### Everything's ready.  Let's show the form! ###
$('#loading').hide()
$('#ready').show()
