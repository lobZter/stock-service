function setSelectStock() {
  var company_id = $('#select_company_id').val();
  var url = '/companies/' + company_id + '/stocks';
  
  $('#select_stock').empty();
  $.get(url, function(data, status) {
    var stocks = JSON.parse(data);
    var i = 0;
    while(i < Object.keys(stocks).length) {
      val = '{"stock_class":"'+stocks[i].stock_class+'","date_issued":"'+stocks[i].date_issued+'"}';
      show = stocks[i].stock_class + ' / ' + stocks[i].date_issued;
  
      $('#select_stock').append("<option value=\'" + val + "\'>" + show + '</option>');
      i++;
    }
  });
}


$(function() {
  setSelectStock();
  
  $('#select_company_id').change(function() {
    setSelectStock();
  });
  
});