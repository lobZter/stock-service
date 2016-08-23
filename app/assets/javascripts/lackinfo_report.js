(function($) {
  "use strict";
  
  $(function() {
   
    $('tr[data-link]').click(function() {
      window.location = $(this).data('link')
    });
    
  });
  
})(jQuery);