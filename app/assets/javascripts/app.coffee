# Mustache styled underscore templtes!
_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};

toaster = new @FFS.Views.ToasterView()
waypoints = new @FFS.Collections.Waypoints()

@FFS.showToaster = (message) ->
  toaster.model.set {message: message}

@FFS.addToCollection = (model) ->
  waypoints.add model

@FFS.removeFromCollection = (model) ->
  waypoints.remove(@model)

@FFS.calculateShares = ->
  waypoints.calculateShares( $('#finalFare').val() )

@FFS.start = (bootstrapData) ->
  if bootstrapData?
    console.log(bootstrapData)

    waypoints = new @Collections.Waypoints(bootstrapData)

    waypoints.each (point) -> point.validateWaypoint()
    window.waypoints = waypoints
    console.log(waypoints.first().attributes)
  else
    #The first waypoint
    new @Views.WaypointView
      parent: $('#origin')
      modelAttrs: {origin: true}

  new @Views.PageControlView({el: '#buttons'})

  new @Views.ReportView({waypoints: waypoints})

  ### Everything's ready.  Let's show the form! ###
  $('#loading').hide()
  $('#ready').show()
