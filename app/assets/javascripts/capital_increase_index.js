(function($) {
  "use strict";

  function setfilterUrl () {
    var url = 'capital_increases?company_id=' + $('#company_filter_input').val();
    $('#company_filter_btn').attr('href', url);
  };

  $(function() {
    setfilterUrl();
  
    $('#company_filter_input').change(function() {
      setfilterUrl();
    });

    $(".capital_increase_index_select2").select2({theme: "bootstrap"});
  
  });

})(jQuery);