ready = ->

  $(".payment_details_button").on 'click', () ->
    $('#payment_details_modal .modal-body').html('')
    $.get(window.location.href+"/payment_details?for_item="+$(this).data('purchasedItem')+"&for_item_id="+$(this).data('purchasedItemId'), (data) ->
      $('#payment_details_modal .modal-body').html(data)
    ).fail () ->
      $('#payment_details_modal .modal-body').html("<span class='lead'> Oops. Couldn't get your payment details. Please try again.</span>")
    
$(document).on('page:load ready', ready)