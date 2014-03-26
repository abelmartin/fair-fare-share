# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#getShares').click (e) ->
    e.preventDefault()

    # $.get '/home/verifyWaypoint?'

    $.get "/home/getShares?#{$('#ffs').serialize()}", (data) ->
      console.log(data)
      $('span.distance').each (idx, elm) ->
        $(elm).html( "(mile: #{data[idx].miles} | %: #{data[idx].percent} | $: #{data[idx].share})" )
