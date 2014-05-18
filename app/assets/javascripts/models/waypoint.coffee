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