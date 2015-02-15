( ( files ) ->

  if ( files? && files.length > 0 )
    files.sortable().disableSelection();

) $( '.files' )