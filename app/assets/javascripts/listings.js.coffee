ready = ->

  $(".enable_listing_button").on 'click', () ->
    $('#listing_purchase_form').attr("action", "/users/"+$(this).data('userId')+"/listings/"+$(this).data('listingId'))
    $('#listing_purchase_form').find('#listing_id').val($(this).data('listingId'))

  $(".publish_button").on "ajax:success", (e, data, status, xhr) ->
    $(this).parents('.listing-item').replaceWith(data)
  .on "ajax:error", (e, xhr, status, error) ->
    alert error

#  $("#edit_listing_form").on "ajax:complete", (e, data, status, xhr) ->
#    $('#activate_buttons').html(data.responseText)

#  $("#submit_and_preview_listing_button").on "click", ->
#    $('input #preview_listing_after_save').val(true)

  $("#listing_web_address").on "change", (e) ->
    $(this).val( $(this).val().replace(/\W/g, "-").toLowerCase() )
    path = $("#name_checker").attr("href").split("=")[0]
    $("#name_checker").attr("href", "#{path}=#{$(this).val()}")
    $("#name_checker").text("Check Availability").removeClass("btn-warning btn-success disabled")

 # $("#edit_listing_form input").on "change", (e) ->
 #   $("#submit_listing_button").attr("value", "Save Changes").addClass("btn-primary")

  $("#name_checker").on "ajax:complete", (e, data, status, xhr) ->
    if JSON.parse(data.responseText).available == true
      $(this).text("Available!").addClass("btn-success disabled")
    else
      $(this).text("Not Available").addClass("btn-warning disabled")

$(document).on('page:load ready', ready)