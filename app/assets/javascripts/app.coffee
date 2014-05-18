# Mustache styled underscore templtes!
_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};

@FFS ?= {}

@FFS.addToCollection = (model) ->
  @objs.waypoints.add model

@FFS.removeFromCollection = (model) ->
  @objs.waypoints.remove(@model)

@FFS.start = ->
  @objs =
    googleServices: new @Lib.GoogleServices()
    waypoints: new @Collections.Waypoints()
    toaster: new @Views.ToasterView()

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