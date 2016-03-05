currency = 
  1: 'USD'
  2: 'RMB'
  3: 'NTD'


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
    # Transaction money
    $('#transaction_fund').val($('#transaction_fund_original').val()/$('#transaction_exchange_rate').val())
    
    return

  $('#transaction_seller_id').change ->
    i_id = $('#transaction_seller_id').val()
    url = '/identities/' + i_id + '/stocks'
    $.get url, (data, status) ->
      stocks = JSON.parse(data)
      i = 0
      console.log stocks
      
      # original currency 
      $('.original_currency').val(currency[stocks[0].company_currency])
      $('#transaction_currency_original').val(stocks[0].company_currency)
      
      
      while i < Object.keys(stocks).length
        # fetch st
        val = stocks[i].company_name + '/' + stocks[i].stock_class + '/' + stocks[i].date_issued
        $('#transaction_stock').append '<option value="' + val + '">' + val + '</option>'

        i++
      return
    return




