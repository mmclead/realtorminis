$(function () {
    // Initialize the jQuery File Upload widget:
    if ($('#fileupload')) {
      var listing_id = $('#current_id').data('id');
      $('#fileupload').fileupload({
        dataType: 'xml',
        sequentialUploads: true,
        disableImageResize: /Android(?!.*Chrome)|Opera/
            .test(window.navigator && navigator.userAgent),
        imageMaxWidth: 800,
        imageCrop: false
      });
      
      // Load existing files:
      $.getJSON("/listings/"+listing_id+"/photos", function (files) {
        $.each(files, function(index, value) { 
          $('#upload_files tbody').append(tmpl('template-uploaded', value));
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
