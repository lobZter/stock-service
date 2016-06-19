function checkForm() {
  
  var flash_str = 
    '<div class="alert alert-danger">'+
    '<ul class="custom-list" style="display: inline-block">';
  
  var fundTotal = parseInt($('#capital_increase_fund').val());
  if(!isNaN(fundTotal)) {
    $('.fund-input').each(function(){
      var val = parseInt($(this).val());
      if(!isNaN(val))
        fundTotal -= val;
    });
    if(fundTotal != 0)
      flash_str += '<li>投資人總資金和不符</li>';
  }
  else {
    flash_str += '<li>投資人總資金和不符</li>';
  }
  
  var StockNumTotal = parseInt($('#capital_increase_stock_num').val());
  if(!isNaN(StockNumTotal)) {
    $('.stock_num-input').each(function(){
      var val = parseInt($(this).val());
      if(!isNaN(val))
        StockNumTotal -= val;
    });
    if(StockNumTotal != 0)
      flash_str += '<li>投資人總股數和不符</li>';
  }
  else {
    flash_str += '<li>投資人總股數和不符</li>';
  }
  
  if(fundTotal == 0 && StockNumTotal == 0)
    return true;
  
  flash_str += 
    '</ul>'+
    '<button type="button" class="close" data-dismiss="alert" aria-label="Close">'+
    '<span aria-hidden="true">&times;</span>'+
    '</button>'+
    '</div>';
    
  $('#flash').empty();
  $('#flash').append(flash_str);
  return false;
  
}