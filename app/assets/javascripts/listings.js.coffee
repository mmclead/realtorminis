$ ->
  $("#make_live_button").on "ajax:success", (e, data, status, xhr) ->
    $(this).text("You are live!").addClass("btn-primary disabled")
  .on "ajax:error", (e, xhr, status, error) ->
    alert "#{error}"

  $("#publish_button").on "ajax:success", (e, data, status, xhr) ->
    $(this).text("Published!").addClass("btn-primary disabled")
  .on "ajax:error", (e, xhr, status, error) ->
    alert "#{error}"
