# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  # Datetime picker format
  $('#transaction_datetimepicker1').datetimepicker({
     format: 'YYYY/MM/DD'
  });

  # Calculate 
  $('input.auto-calculate').change ->
    # Apply to exchange rate
    $('#transaction_money').val($('#transaction_fund').val()*$('#transaction_exchange_rate').val())
    # Stock number
    $('#transaction_stock_num').val($('#transaction_money').val()/$('#transaction_stock_price').val())
    return
    
  $('#transaction_buyer_id').change ->
    
    return