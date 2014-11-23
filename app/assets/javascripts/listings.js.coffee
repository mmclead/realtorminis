$ ->
  $("#make_live_button").on "ajax:success", (e, data, status, xhr) ->
    alert "The Listing is being deployed."
  .on "ajax:error", (e, xhr, status, error) ->
    alert "#{error}"