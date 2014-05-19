@FFS ?=  {}
@FFS.Views ?=  {}

@FFS.Views.WaypointView = Backbone.View.extend
  className: 'waypoint'

  template: '#tmpWaypoint'

  events:
    'click .removeWaypoint': 'removeView'
    'click .getCurrentLocation': 'getCurrentLocation'
    'keydown .address' : 'keydownAddressUpdate'

  initialize: (options = {}) ->
    @$parent = if options.parent? then options.parent else $('#waypoints')
    @model = new window.FFS.Models.Waypoint(options.modelAttrs)
    window.FFS.addToCollection @model

    @listenTo(@model, 'change:address', @validateWaypoint)
    @listenTo(@model, 'change:addressLatLng', @validateWaypoint)
    @render()

  removeView: ->
    window.FFS.removeFromCollection @model
    @remove()

  getCurrentLocation: ->
    $button = $('.getCurrentLocation', @$el)

    #disable UI
    $('img.loader', @$el).show()
    $button.prop('disabled', true)

    @model.getCurrentLocation ->
      #Re-enable as callback
      $button.prop('disabled', false)
      $('img.loader', @$el).hide()

  keydownAddressUpdate: (e) ->
    #Something like @$('input:focus')
    if e.which == 13
      @model.set({address: $('.address', @$el).val()})

  validateWaypoint: ->
    $('img.loader', @$el).show()

    @model.validateWaypoint =>
      $('.address', @$el).val(@model.get('address'))
      $('img.loader', @$el).hide()

  render: ->
    @$el.append(_.template($(@template).html(), @model.attributes))
    if @model.get('origin')
      $('.addressInputControlHeader', @$el).prepend('<label> Starting Location </label>')
    else
      $('.addressInputControlHeader', @$el).prepend('<label> Cab Stop </label>')
    @$parent.append(@$el)

    unless navigator.geolocation
      @$el.find('.getCurrentLocation').addClass('off')

    $('input.address', @$el).focus()
    return @
