(function($) {
  "use strict";
  
  var currency = {
    1: 'USD',
    2: 'RMB',
    3: 'NTD'
  };
  
  var stocks = void 0;
  
  function setCurrency() {
    var i_id, url;
    i_id = $('#capital_increase_identity_id').val();
    url = '/identities/' + i_id;
    return $.get(url, function(data, status) {
      var company;
      company = JSON.parse(data);
      $('#capital_increase_currency').val(company.currency);
      return $('#currency').val(currency[company.currency]);
    });
  };
  
  function setStockClass() {
    var i_id, url;
    i_id = $('#capital_increase_identity_id').val();
    url = '/identities/' + i_id + '/stocks';
    $('#stock_class_list').empty();
    $.get(url, function(data, status) {
      var i, results, val;
      stocks = JSON.parse(data);
      i = 0;
      results = [];
      while (i < Object.keys(stocks).length) {
        val = stocks[i].stock_class;
        $('#stock_class_list').append('<option value="' + val + '"></option>');
        results.push(i++);
      }
      return results;
    });
  };
  
  $(function() {
    setCurrency();
    setStockClass();
    
    $('#capital_increase_datetimepicker1').datetimepicker({
      format: 'YYYY/MM/DD'
    });
    
    $('#capital_increase_datetimepicker2').datetimepicker({
      format: 'YYYY/MM/DD'
    });
    
    $('.auto-calculate').change(function() {
      $('#capital_increase_stock_num').val(
        $('#capital_increase_fund').val() / $('#capital_increase_stock_price').val());
    });
    
    $('#capital_increase_identity_id').change(function() {
      setCurrency();
      setStockClass();
    });
    
    $(".investor_select2").select2({
      theme: "bootstrap"
    });
    
    $(".remove_btn").click(function() {
      $(this).parent().remove();
    });
  });

})(jQuery);