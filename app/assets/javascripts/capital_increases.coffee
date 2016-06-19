currency = 
  1: 'USD'
  2: 'RMB'
  3: 'NTD'
  
stocks = undefined

setCurrency = ->
  i_id = $('#capital_increase_identity_id').val()
  url = '/identities/' + i_id
  $.get url, (data, status) ->
    company = JSON.parse(data)
    $('#capital_increase_currency').val(company.currency)
    $('#currency').val(currency[company.currency])
    
setfilterUrl = ->
  url = 'capital_increases?identity_id=' + $('#company_filter_input').val()
  $('#company_filter_btn').attr 'href', url
  return
  
setStockClass = ->
  i_id = $('#capital_increase_identity_id').val()
  url = '/identities/' + i_id + '/stocks'
  
  $('#stock_class_list').empty();
  $.get url, (data, status) ->
    stocks = JSON.parse(data)
    i = 0
    while i < Object.keys(stocks).length
      val = stocks[i].stock_class
      
      $('#stock_class_list').append '<option value="' + val + '"></option>'
      i++
  return


$('body.capital_increases_new').ready ->
  setCurrency()
  setStockClass()
  
  # Datetime picker format
  $('#capital_increase_datetimepicker1').datetimepicker({
    format: 'YYYY/MM/DD'
  });
  
  $('#capital_increase_datetimepicker2').datetimepicker({
    format: 'YYYY/MM/DD'
  });

  # Calculate 
  $('.auto-calculate').change ->
    # Stock number
    $('#capital_increase_stock_num').val($('#capital_increase_fund').val()/$('#capital_increase_stock_price').val())
    return

  $('#capital_increase_identity_id').change ->
    setCurrency()
    setStockClass()
    return
    
  $(".investor_select2").select2({theme: "bootstrap"})
  
  $(".remove_btn").click ->
    $(this).parent().remove()
    return
  
  return
  
  
$('body.capital_increases_index').ready ->
  setfilterUrl()
  
  $('#company_filter_input').change ->
    setfilterUrl()
    return

  $(".capital_increase_index_select2").select2({theme: "bootstrap"});
  
  return
