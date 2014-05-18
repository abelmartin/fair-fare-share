@FFS ?=  {}
@FFS.Views ?=  {}

@FFS.Views.ReportView = Backbone.View.extend
  el: '#reports'

  initialize: (options) ->
    @listenTo window.FFS.objs.waypoints, 'sharesCalculated', @render

  render: ->
    #clear what we have
    @$el.empty()
    newReports = []

    #Add the elements to an array while building them from template
    window.FFS.objs.waypoints.each (wpoint) ->
      newReports.push _.template( "<div class='report'> ({{mileage}} miles, {{percentage}}%, ${{fareShare}}) </div>", wpoint.attributes )

    #A single insertion into the DOM is better than ittering the insertions
    @$el.html( newReports )