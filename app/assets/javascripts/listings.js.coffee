ready = ->

  $(".enable_listing_button").on 'click', () ->
    $('#listing_purchase_form').attr("action", "/listings/"+$(this).data('listingId'))
    $('#listing_purchase_form').find('#listing_id').val($(this).data('listingId'))

  $(".publish_button").on "ajax:send", (xhr) ->
    $(this).data("original_text", $(this).text())
    $(this).text($(this).data("loading-text"))
    $(this).addClass('btn-primary')
  .on "ajax:success", (e, data, status, xhr) ->
    $(this).parents('.listing-item').replaceWith(data)
  .on "ajax:error", (e, xhr, status, error) ->
    $(this).text($(this).data("original-text"))
    alert error

  $("#listing_web_address").on "blur", (e) ->
    $(this).val( $(this).val().replace(/\W/g, "-").toLowerCase() )
    path = $("#name_checker").attr("href").split("=")[0]
    $("#name_checker").attr("href", "#{path}=#{$(this).val()}")
    $("#name_checker").text("Check Site Name Availability").removeClass("btn-warning btn-success disabled")

  $("#name_checker").on "ajax:complete", (e, data, status, xhr) ->
    if (JSON.parse(data.responseText).available == true) || $("#listing_web_address").val() == $("#listing_web_address").data('currentAddress')
      $(this).text("Available!").addClass("btn-success disabled")
    else
      $(this).text("Not Available").addClass("btn-warning disabled")

  $(".add_custom_domain").on 'click', () ->
    $('#domain_name_purchase_form').find('#domain_name_listing_id').val($(this).data('listingId'))
    $('.stripe-button-el').hide()

  $("#domain_name_domain").on "keyup", (e) ->    
    $("#domain_name_checker").text("Check Availability").removeClass("btn-warning btn-success disabled")
    $('.stripe-button-el').hide()

  $("#domain_name_tld").on "change", (e) ->
    $("#domain_name_checker").text("Check Availability").removeClass("btn-warning btn-success disabled")
    $('.stripe-button-el').hide()


  $("#domain_name_checker").on 'click', () ->
    $('#domain_name_domain').val( $('#domain_name_domain').val().replace(/\W/g, "-").toLowerCase() )
    $('#domain_name_name').val( $('#domain_name_domain').val() + '.' + $('#domain_name_tld').val() )
    path = $("#domain_name_checker").attr("href").split("=")[0]
    $("#domain_name_checker").attr("href", "#{path}=#{$('#domain_name_name').val()}")

  $("#domain_name_checker").on "ajax:beforeSend", (e, xhr, settings) ->
    $(this).text("Checking...").addClass("disabled")
  
  $("#domain_name_checker").on "ajax:complete", (e, data, status, xhr) ->
    if JSON.parse(data.responseText).available == true
      $(this).text("Available!").addClass("btn-success disabled")
      $('.stripe-button-el').show()
    else
      $(this).text("Not Available").addClass("btn-warning disabled")
      

$(document).on('page:load ready', ready)
  