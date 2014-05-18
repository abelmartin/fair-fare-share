@FFS ?=  {}
@FFS.Collections ?=  {}

@FFS.Collections.Waypoints = Backbone.Collection.extend
  model: window.FFS.Models.Waypoint

  initialize: ->
    @on 'add', (waypoint) ->
      @each (point) -> point.set({destination: false}, {silent: true})
      waypoint.set({destination: true}, {silent: true})

    @on 'remove', (waypoint) ->
      @each (point) -> point.set({destination: false}, {silent: true})
      lastPoint = waypoints.last()
      lastPoint.set({destination: true}, {silent: true}) unless lastPoint.get('origin')