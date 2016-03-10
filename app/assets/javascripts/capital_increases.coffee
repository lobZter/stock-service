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
<<<<<<< HEAD
  # setCurrency()
=======
  setCurrency()
>>>>>>> 2cc9bc8acda680a3a5ed999e34df6a18246be6d9
  
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
    
  