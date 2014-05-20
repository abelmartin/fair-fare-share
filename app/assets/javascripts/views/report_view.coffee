@FFS ?=  {}
@FFS.Views ?=  {}

@FFS.Views.ReportView = Backbone.View.extend
  el: '#reports'

  template: '#tmpReport'

  initialize: (options) ->
    @waypoints = options.waypoints
    @listenTo @waypoints, 'sharesCalculated', @render

  render: ->
    @$el.empty()
    newReports = []

    #Add the elements to an array while building them from template
    @waypoints.each (wpoint) =>
      newReports.push _.template( $(@template).html(), wpoint.attributes ) unless wpoint.get('origin')

    #A single insertion into the DOM is better than ittering the insertions
    @$el.html( newReports )