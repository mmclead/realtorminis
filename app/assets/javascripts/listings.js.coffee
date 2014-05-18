$ ->
  $("#make_live_button").on "ajax:success", (e, data, status, xhr) ->
    alert "The Listing is being deployed."