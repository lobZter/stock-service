currency = 
  1: 'USD'
  2: 'RMB'
  3: 'NTD'
  
setCurrency = ->
  
  i_id = $('#capital_increase_identity_id').val()
  url = '/identities/' + i_id
  $.get url, (data, status) ->
    company = JSON.parse(data)
    $('#capital_increase_currency').val(currency[company.currency])
  
$('body.capital_increases_new').ready ->
  setCurrency()
  
  $(".capital_increase_select2").select2({theme: "bootstrap"});
  
  # Datetime picker format
  $('#capital_increase_datetimepicker1').datetimepicker({
     format: 'YYYY/MM/DD'
  });

  # Calculate 
  $('.auto-calculate').change ->
    # Stock number
    $('#capital_increase_stock_num').val($('#capital_increase_fund').val()/$('#capital_increase_stock_price').val())
    return

  $('#capital_increase_identity_id').change ->
    setCurrency()
    
    return
    
  return