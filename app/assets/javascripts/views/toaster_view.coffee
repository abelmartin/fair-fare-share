@FFS ?=  {}
@FFS.Views ?=  {}

@FFS.Views.ToasterView = Backbone.View.extend
  el: '#alert'

  initialize: (options) ->
    @model = new Backbone.Model()
    @listenTo( @model, 'change:message', @render )

  render: ->
    resetToaster = =>
      @$el.fadeOut()
      @model.set {message: ''}, {silent: true}

    @$el.html( @model.get('message') )

    @$el.show()
    window.setTimeout resetToaster, 3000

    return @