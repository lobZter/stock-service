# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  # Datetime picker format
  $('#transaction_datetimepicker1').datetimepicker({
     format: 'YYYY/MM/DD'
  });
  
  $('#transaction_datetimepicker2').datetimepicker({
     format: 'YYYY/MM/DD'
  });
  
  $('#transaction_datetimepicker3').datetimepicker({
     format: 'YYYY/MM/DD'
  });
    
  $('#transaction_datetimepicker4').datetimepicker({
     format: 'YYYY/MM/DD'
  });

  # Calculate 
  $('input.auto-calculate').change ->
    # Stock number
    $('#transaction_stock_num').val($('#transaction_money').val()/$('#transaction_stock_price').val())
    return
    
  $('#transaction_buyer_id').change ->
    
    return