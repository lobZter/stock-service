function setStockOption() {
  var company_id = $('#select_company_id').val();
  var url = '/companies/' + company_id + '/stocks';
  
  $('#select_stock').empty();
  $.get(url, function(data, status) {
    var stocks = JSON.parse(data);
    var i = 0;
    while(i < Object.keys(stocks).length) {
      val = "{'stock_class':'"+stocks[i].stock_class+"','date_issued':'"+stocks[i].date_issued+"'}";
      show = stocks[i].stock_class + ' / ' + stocks[i].date_issued;
  
      $('#select_stock').append("<option value=\"" + val + "\">" + show + "</option>");
      i++;
    }
      
    $('#select_stock').append("<option value='0'>0</option>");
  });
  
}

var result = {};
function setInput() {
  
  location.search.substr(1).split('&').forEach(function(part) {
    if(part != '') {
      var item = part.split('=');
      result[decodeURIComponent(item[0])] = decodeURIComponent(item[1]);
    }
  });
    
  if (result["company_id"] != undefined && result["company_id"] != "")
    $('#select_company_id').val(result.company_id);
  if (result["start_time"] != "" && result["start_time"] != "")
    $('#start_time').val(result.start_time);
  if (result["end_time"] != "" && result["end_time"] != "")
    $('#end_time').val(result.end_time);
    
  var company_id = $('#select_company_id').val();
  var url = '/companies/' + company_id + '/stocks';
  
  $('#select_stock').empty();
  $.get(url, function(data, status) {
    var stocks = JSON.parse(data);
    var i = 0;
    while(i < Object.keys(stocks).length) {
      val = "{'stock_class':'"+stocks[i].stock_class+"','date_issued':'"+stocks[i].date_issued+"'}";
      show = stocks[i].stock_class + ' / ' + stocks[i].date_issued;
  
      if (result["stock"] != undefined && result["stock"] != "" &&  result["stock"] == val)
        $('#select_stock').append("<option value=\"" + val + "\" selected=\"selected\">" + show + "</option>");
      else
        $('#select_stock').append("<option value=\"" + val + "\">" + show + "</option>");
      
      i++;
    }
  });
}

$(function() {
  setInput();
  
  $('#select_company_id').change(function() {
    setStockOption();
  });
  
});