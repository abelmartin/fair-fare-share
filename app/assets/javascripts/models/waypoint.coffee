@FFS ?=  {}
@FFS.Models ?=  {}

@FFS.Models.Waypoint = Backbone.Model.extend
  defaults:
    address: ''
    addressLatLng: null
    addressVerified: false
    fareShare: 'zzz'
    mileage: 'xxx'
    percentage: 'yyy'
    origin: false
    destination: false

  getCurrentLocation: (callback) ->
    geoOptions =
      enableHighAccuracy: false
      timeout: 3000
      maximumAge: 30000

    geoFail = (err) ->
      window.FFS.showToaster err.message
      callback()

    geoSucess = (coordResponse) =>
      @set
        addressLatLng: new google.maps.LatLng(
          coordResponse.coords.latitude,
          coordResponse.coords.longitude
        )
      callback()

    navigator.geolocation.getCurrentPosition( geoSucess, geoFail, geoOptions )

  validateWaypoint: (callback) ->
    if @get('addressLatLng')? && @get('address') == ''
      geoParam = {location: @get('addressLatLng')}
    else
      geoParam = {address: @get('address')}

    #This is gross. :-( Seems like creating geocoder objects would be better
    window.FFS.objs.googleServices.geocoder.geocode geoParam, (data, status) =>
      $('img.loader', @$el).show()

      foundLoc = _.find data, (result) ->
        result.types[0] == 'street_address'

      if foundLoc?
        latLng = foundLoc.geometry.location
        @set(
          {address: foundLoc.formatted_address, addressLatLng: latLng},
          {silent: true}
        )
      else
        window.FFS.showToaster "Address Not Found: #{@get('address')}"

      callback()
