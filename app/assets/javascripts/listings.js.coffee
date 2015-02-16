$ ->

  $(".enable_listing_button").on 'click', () ->
    $('#listing_purchase_form').attr("action", "/users/"+$(this).data('userId')+"/listings/"+$(this).data('listingId'))
    $('#listing_purchase_form').find('#listing_id').val($(this).data('listingId'))

  $("#make_live_button").on "ajax:success", (e, data, status, xhr) ->
    $(this).text("You are live!").addClass("btn-primary disabled")
  .on "ajax:error", (e, xhr, status, error) ->
    alert error

  $("#publish_button").on "ajax:success", (e, data, status, xhr) ->
    $(this).text("Published!").addClass("btn-primary disabled")
  .on "ajax:error", (e, xhr, status, error) ->
    alert error

  $("#edit_listing_form").on "ajax:complete", (e, data, status, xhr) ->
    $('#activate_buttons').html(data.responseText)

  $("#submit_and_preview_listing_button").on "click", ->
    $('input #preview_listing_after_save').val(true)
