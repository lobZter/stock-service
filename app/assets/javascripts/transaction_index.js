(function($) {
  "use strict";
  
  var set_field = "set_all";
  
  function setView () {
    var query = location.search.substr(1);
    var result = {};
    
    query.split('&').forEach(function(part) {
      var item;
      if (part !== '') {
        item = part.split('=');
        result[decodeURIComponent(item[0])] = decodeURIComponent(item[1]);
      }
    });
    
    if (result["buyer_id"] !== void 0) {
      $('#buyer_filter_input').val(result.buyer_id);
    }
    
    if (result["seller_id"] !== void 0) {
      $('#seller_filter_input').val(result.seller_id);
    }
    
    if (result["company_id"] !== void 0 && result["stock_class"] !== void 0 && result["date_issued"] !== void 0) {
      var stock_option = '{\'company_id\': \'' + result.company_id + 
        '\', \'stock_class\': \'' + result.stock_class + 
        '\', \'date_issued\': \'' + result.date_issued + '\'}';
      $('#stock_filter_input').val(stock_option);
    }
    
    if ((result["set_all"] === void 0 && result["set_completed"] === void 0 && result["set_not_completed"] === void 0) || result["set_all"] !== void 0) {
      $('#set_all').addClass("active");
      $('#set_completed').removeClass("active");
      $('#set_not_completed').removeClass("active");
    }
    
    if (result["set_completed"] !== void 0) {
      $('#set_all').removeClass("active");
      $('#set_completed').addClass("active");
      $('#set_not_completed').removeClass("active");
    }
    
    if (result["set_not_completed"] !== void 0) {
      $('#set_all').removeClass("active");
      $('#set_completed').removeClass("active");
      $('#set_not_completed').addClass("active");
    }
  }
    
  function setTransactionFilterUrl () {
    var stock, url;

    url = 'transactions?';
    
    if ($('#buyer_filter_input').val() !== '0') {
      url += '&buyer_id=' + $('#buyer_filter_input').val();
    }
    
    if ($('#seller_filter_input').val() !== '0') {
      url += '&seller_id=' + $('#seller_filter_input').val();
    }
    
    if ($('#stock_filter_input').val() !== '0') {
      stock = JSON.parse($('#stock_filter_input').val().replace(/'/g, '"'));
      url += '&company_id=' + stock.company_id + '&stock_class=' + stock.stock_class + '&date_issued=' + stock.date_issued;
    }


    $('#filter_btn').attr('href', url);
    
    $('#set_all').attr('href', url + '&set_all=1');
    
    $('#set_completed').attr('href', url + '&set_completed=1');
    
    $('#set_not_completed').attr('href', url + '&set_not_completed=1');
  }
  
  
  $(function() {
    
    setView();
    setTransactionFilterUrl();
    
    $('#buyer_filter_input').change(function() {
      setTransactionFilterUrl();
    });
    
    $('#seller_filter_input').change(function() {
      setTransactionFilterUrl();
    });
    
    $('#stock_filter_input').change(function() {
      setTransactionFilterUrl();
    });
        
    $(".bootstrap_select2").select2({theme: "bootstrap"});
      
  });


})(jQuery);