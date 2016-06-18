function showHide(id) {
  
  if($("#"+id).is(':visible'))
    $("#"+id).slideUp();
  else
    $("#"+id).slideDown();
}

function setInput() {
  var result = {};
  
  location.search.substr(1).split('&').forEach(function(part) {
    if(part != '') {
      var item = part.split('=');
      result[decodeURIComponent(item[0])] = decodeURIComponent(item[1]);
    }
  });
    
  if (result["id"] != undefined && result["id"] != "") {
    $('#select_capital_increase').val(result.id);
  }
}


$(function() {
  setInput();
});