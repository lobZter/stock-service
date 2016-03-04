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

  $('#transaction_seller_id').change ->
    i_id = $('#transaction_seller_id').val()
    url = '/identities/' + i_id + '/stocks'
    $.get url, (data, status) ->
      stocks = JSON.parse(data)
      i = 0
      while i < Object.keys(stocks).length
        val = stocks[i].company_name + '/' + stocks[i].stock_class + '/' + stocks[i].date_issued
        $('#transaction_stock').append '<option value="' + val + '">' + val + '</option>'
        i++
      return
    return




