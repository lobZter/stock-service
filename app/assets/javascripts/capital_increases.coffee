currency = 
  1: 'USD'
  2: 'RMB'
  3: 'NTD'
  
setCurrency = ->
  i_id = $('#capital_increase_identity_id').val()
  url = '/identities/' + i_id
  $.get url, (data, status) ->
    company = JSON.parse(data)
    console.log currency[company.currency]
    $('#capital_increase_currency').val(currency[company.currency])
  
$ ->
  setCurrency()
  
  # Datetime picker format
  $('#capital_increases_datetimepicker1').datetimepicker({
     format: 'YYYY/MM/DD'
  });

  # Calculate 
  $('auto-calculate').change ->
    # Stock number
    $('#capital_increase_stock_num').val($('#capital_increase_fund').val()/$('#capital_increase_stock_price').val())
    return

  $('#capital_increase_identity_id').change ->
    setCurrency()
    
    return
    
  