@FFS ?=  {}
@FFS.Views ?=  {}

@FFS.Views.PageControlView = Backbone.View.extend
  el: '#buttons'

  events:
    'click #addWaypoint': 'addWaypoint'
    'click #calculateShares': 'calculateShares'
    # 'click #viewWaypoints': 'viewWaypoints'
    # 'click #viewMap': 'viewMap'

  addWaypoint: -> new window.FFS.Views.WaypointView

  calculateShares: -> window.FFS.objs.waypoints.calculateShares()