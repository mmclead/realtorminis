$(function () {
    // Initialize the jQuery File Upload widget:
    if ($('#fileupload')) {
      var listing_id = $('#current_id').data('id');
      bucketUrl = $('#current_id').data('bucket');
      $('#fileupload').attr('action', bucketUrl);
      $('#fileupload').fileupload({
        dataType: 'xml',
        sequentialUploads: false,
        disableImageResize: /Android(?!.*Chrome)|Opera/
            .test(window.navigator && navigator.userAgent),
        imageMaxWidth: 800,
        imageMaxHeight: 800,
        imageCrop: false,
        prependFiles: true,
      });

      $('.fileupload-buttonbar .toggle').remove()
      $('.fileupload-buttonbar .delete').remove()
      $('.fileupload-buttonbar .cancel').hide()
      $('.fileupload-buttonbar .start').hide()
      
      // Load existing files:
      $.getJSON("/listings/"+listing_id+"/photos", function (files) {
        $.each(files, function(index, value) { 
          $('#listing_photos tbody').append(tmpl('template-uploaded', value));
        });
  
        $( '#listing_photos tbody' ).sortable(
          {
            placeholder: "photo-place-holder",
            handle: ".photo-handle",
            axis: "y",
            cursor: "move",
            stop: function (event, ui) {
              $.post("/listings/"+listing_id+"/photos/sort_photos", { photos: $( '#listing_photos tbody' ).sortable( "toArray" ) } )
                .success( function ( result ) {
                  $('#sort_success_message').text("Photos have been updated").fadeIn(1000).fadeOut(3000);
                })
                .fail( function ( error ) {
                  $('#sort_failure_message').text("Photos could not be updated").fadeIn(1000).fadeOut(3000);
              })
            }
          }
        ).disableSelection();

        $(".delete-photo").on("ajax:success", function (e, data, status, xhr) {
          $(this).parents('tr').addClass('danger').fadeOut(1500);
        });

      });
    
      // used by the jQuery File Upload
      var fileUploadErrors = {
        maxFileSize: 'File is too big',
        minFileSize: 'File is too small',
        acceptFileTypes: 'Filetype not allowed',
        maxNumberOfFiles: 'Max number of files exceeded',
        uploadedBytes: 'Uploaded bytes exceed file size',
        emptyResult: 'Empty file upload result'
      };
    }
});
