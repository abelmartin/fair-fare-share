@FFS ?= {}
@FFS.Lib ?= {}

class @FFS.Lib.GoogleServices
  constructor: ->
    @geocoder = new google.maps.Geocoder()
    @directionsService = new google.maps.DirectionsService()
