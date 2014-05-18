@FFS ?=  {}
@FFS.Views ?=  {}

@FFS.Views.WaypointView = Backbone.View.extend
  className: 'waypoint'

  template: '#tmpWaypoint'

  events:
    'click .removeWaypoint': 'removeView'
    'click .getCurrentLocation': 'getCurrentLocation'
    'keydown .address' : 'keydownAddressUpdate'

  initialize: (options = {}) ->
    @$parent = if options.parent? then options.parent else $('#waypoints')

    @geocoder = options.geocoder
    @model = new window.FFS.Models.Waypoint(options.modelAttrs)
    window.FFS.addToCollection @model

    @listenTo(@model, 'change:address', @validateWaypoint)
    @listenTo(@model, 'change:addressLatLng', @validateWaypoint)
    @render()

  removeView: ->
    window.FFS.removeFromCollection @model
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
