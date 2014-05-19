# Mustache styled underscore templtes!
_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};

toaster = new @FFS.Views.ToasterView()

@FFS.showToaster = (message) ->
  toaster.model.set {message: message}

@FFS.addToCollection = (model) ->
  @objs.waypoints.add model

@FFS.removeFromCollection = (model) ->
  @objs.waypoints.remove(@model)

@FFS.start = ->
  #These are objects that should be instatiated once.
  @objs =
    googleServices: new @Lib.GoogleServices()
    waypoints: new @Collections.Waypoints()

  #The first waypoint
  new @Views.WaypointView
    parent: $('#origin')
    geocoder: @objs.googleServices.geocoder
    modelAttrs: {origin: true}

  new @Views.PageControlView
    el: '#buttons'
    googleServices: @objs.googleServices

  new @Views.ReportView()

  ### Everything's ready.  Let's show the form! ###
  $('#loading').hide()
  $('#ready').show()