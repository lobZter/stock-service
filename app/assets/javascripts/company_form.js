(function($) {
  "use strict";

  $(function() {
    $('#datetimepicker1').datetimepicker({
       format: 'YYYY/MM/DD'
    });
    $('#datetimepicker2').datetimepicker({
       format: 'YYYY/MM/DD'
    });
    
    // Calculate stock num
    $('input.auto-calculate').change(function() {
      $('#company_stock_num').val(
        Math.floor(
          $('#company_fund').val() / $('#company_stock_price').val()));
    });
  
    $(".staff_select2").select2({theme: "bootstrap"})
    
    $(".remove_btn").click(function() {
      $(this).parent().remove()
    });
    
  });

})(jQuery);