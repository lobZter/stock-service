currency = 
  1: 'USD'
  2: 'RMB'
  3: 'NTD'
  
stocks = undefined

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
  $('.auto-calculate').change ->
    # Stock number
    $('#transaction_stock_num').val($('#transaction_fund').val()/$('#transaction_stock_price').val())
    # Transaction money
    $('#transaction_fund').val($('#transaction_fund_original').val()/$('#transaction_exchange_rate').val())
    return
    
  $('#transaction_seller_id').change ->
    i_id = $('#transaction_seller_id').val()
    url = '/identities/' + i_id + '/stocks'
    $.get url, (data, status) ->
      stocks = JSON.parse(data)
      $('.currency').val(currency[stocks[0].company_currency])
      $('#transaction_currency').val(stocks[0].company_currency)
      
      $('#transaction_stock').empty();
      i = 0
      while i < Object.keys(stocks).length
        val = '{"company_id":'+stocks[i].company_id+',"stock_class":"'+stocks[i].stock_class+'","date_issued":"'+stocks[i].date_issued+'"}'
        show = stocks[i].company_name + '/' + stocks[i].stock_class + '/' + stocks[i].date_issued
        
        $('#transaction_stock').append "<option value=\'" + val + "\'>" + show + '</option>'
        i++
      return
    return

  $('#transaction_stock').change ->
    # original currency 
    index = $("#transaction_stock").prop('selectedIndex')
    $('.currency').val(currency[stocks[index].company_currency])
    $('#transaction_currency').val(stocks[index].company_currency)

