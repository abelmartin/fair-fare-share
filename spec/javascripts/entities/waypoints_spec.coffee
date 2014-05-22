describe 'Waypoints', ->
  waypoints = null

  beforeEach ->
    jasmine.Ajax.install()
    stops = [
      {address: '3064 34th st, astoria, NY 11103, USA', origin: true}
      {address: '40 Fulton Street, New York, NY 10038, USA'}
      {address: '50 Jay Street, Brooklyn, NY 11201, USA'}
      {address: '30 W 26th St, ny ny', destination: true}
    ]
    waypoints = new window.FFS.Collections.Waypoints(stops)

  it 'has 4 models', ->
    expect(waypoints.models.length).toBe(4)

  describe '#calculateShares', ->
    it 'calls FFS#showToaster if an origin is missing', ->
      waypoints.models[0].set({origin: false},{silent: true})
      spyOn(window.FFS, 'showToaster')
      waypoints.calculateShares(50)

      expect(window.FFS.showToaster)
        .toHaveBeenCalledWith('You must set a starting location')

    it 'calls FFS#showToaster if there is less than 2 stops', ->
      waypoints.remove(waypoints.last())
      waypoints.remove(waypoints.last())
      waypoints.first().set({addressLatLng: true}, {silent: true})

      spyOn(window.FFS, 'showToaster')
      waypoints.calculateShares(50)

      expect(window.FFS.showToaster)
        .toHaveBeenCalledWith('Please Choose 2 Or More Cab Stops')

  describe '#_processResponse', ->
    beforeEach ->
      waypoints.totalFare = 100

    it 'assigns expected percentage to models', ->
      waypoints._processResponse(
        GoogleResponses.directions.success.responseText
        GoogleResponses.directions.success.status
      )

      expect(waypoints.models[1].get('percentage')).toBe(25)
      expect(waypoints.models[2].get('percentage')).toBe(35)
      expect(waypoints.models[3].get('percentage')).toBe(40)

    it 'assigns expected share to models', ->
      waypoints._processResponse(
        GoogleResponses.directions.success.responseText
        GoogleResponses.directions.success.status
      )

      expect(waypoints.models[1].get('fareShare')).toBe(25.00)
      expect(waypoints.models[2].get('fareShare')).toBe(35.00)
      expect(waypoints.models[3].get('fareShare')).toBe(40.00)

    it 'assigns expected mileage to models', ->
      waypoints._processResponse(
        GoogleResponses.directions.success.responseText
        GoogleResponses.directions.success.status
      )

      expect(waypoints.models[1].get('mileage')).toBe('bar mi')
      expect(waypoints.models[2].get('mileage')).toBe('gaz mi')
      expect(waypoints.models[3].get('mileage')).toBe('qat mi')

    it 'triggers "sharesCalculated"', ->
      spyOn(waypoints, 'trigger')
      waypoints._processResponse(
        GoogleResponses.directions.success.responseText
        GoogleResponses.directions.success.status
      )

      expect(waypoints.trigger).toHaveBeenCalledWith('sharesCalculated')

