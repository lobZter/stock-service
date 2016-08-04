var currency = {
  1: 'USD',
  2: 'RMB',
  3: 'NTD'
};
var stocks = undefined;

function setCurrency() {
  var index = $("#transaction_stock").prop('selectedIndex');
  $('.currency').val(currency[stocks[index].currency]);
  $('#transaction_currency').val(stocks[index].currency);
}

function setStock() {
  var url = '/identities/' + $('#transaction_seller_id').val() + '/stocks';
  
  $('#transaction_stock').empty();
  $.get(url, function(data) {
    stocks = JSON.parse(data);
    for(i=0 ; i<Object.keys(stocks).length; i++) {
      var val = '{"id":' + stocks[i].id +
        ',"company_id":' + stocks[i].company_id +
        ',"stock_class":"' + stocks[i].stock_class +
        '","date_issued":"' + stocks[i].date_issued +'"}';
      var show = stocks[i].company_name + ' / ' + stocks[i].stock_class + ' / ' + stocks[i].date_issued;
  
      $('#transaction_stock').append("<option value=\'" + val + "\'>" + show + '</option>');
    }
    setCurrency();
  });
}

$(function() {
  
  setStock();
    
  $('.calculate-fund').change(function() {
    $('#transaction_fund').val(
      $('#transaction_fund_original').val() / $('#transaction_exchange_rate').val());
  });
   
  $('.calculate-stocknum').change(function() {
    $('#transaction_stock_num').val(
      Math.floor(
        $('#transaction_fund').val() / $('#transaction_stock_price').val()));
  });
 
  $('#transaction_seller_id').change(function() {
    setStock();
  });

  $('#transaction_stock').change(function() {
    setCurrency();
  });
  
  $(".bootstrap_select2").select2({theme: "bootstrap"});
  
  // Datetime picker format
  $('#transaction_datetimepicker1').datetimepicker({
     format: 'YYYY-MM-DD'
  });
  
  $('#transaction_datetimepicker2').datetimepicker({
     format: 'YYYY-MM-DD'
  });
  
  $('#transaction_datetimepicker3').datetimepicker({
     format: 'YYYY-MM-DD'
  });
  
  $('#transaction_datetimepicker4').datetimepicker({
     format: 'YYYY-MM-DD'
  });
  
  $('#transaction_datetimepicker5').datetimepicker({
     format: 'YYYY-MM-DD'
  });
  
  $('#transaction_datetimepicker6').datetimepicker({
     format: 'YYYY-MM-DD'
  });

});