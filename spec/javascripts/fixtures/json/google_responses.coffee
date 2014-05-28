# We need to still multiply by the percentage of the trip,
# then divide for the remaining riders in the car.
window.GoogleResponses =
  directions:
    success:
      status: 200
      responseText:
        routes: [
          legs: [
            { distance: {value: 2100, text: 'bar mi'} }
            { distance: {value: 3900, text: 'gaz mi'} }
            { distance: {value: 4000, text: 'qat mi'} }
          ]
        ]
