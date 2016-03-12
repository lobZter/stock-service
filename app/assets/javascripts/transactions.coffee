currency = 
  1: 'USD'
  2: 'RMB'
  3: 'NTD'
  
stocks = undefined

setCurrency = ->
  index = $("#transaction_stock").prop('selectedIndex')
  $('.currency').val(currency[stocks[index].currency])
  $('#transaction_currency').val(stocks[index].currency)

setStock = ->
  i_id = $('#transaction_seller_id').val()
  url = '/identities/' + i_id + '/stocks'
  
  $('#transaction_stock').empty();
  $.get url, (data, status) ->
    stocks = JSON.parse(data)
    i = 0
    while i < Object.keys(stocks).length
      val = '{"id":'+stocks[i].id+',"company_id":'+stocks[i].company_id+',"stock_class":"'+stocks[i].stock_class+'","date_issued":"'+stocks[i].date_issued+'"}'
      show = stocks[i].company_name + ' / ' + stocks[i].stock_class + ' / ' + stocks[i].date_issued
  
      $('#transaction_stock').append "<option value=\'" + val + "\'>" + show + '</option>'
      i++
    setCurrency()
  return

@setPreview = (input, id) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      $(id).attr 'src', e.target.result
      return

    reader.readAsDataURL input.files[0]
  return


@setModal = (image) ->
  $('#enlarge_image').attr 'src', image.src
  $('#image_modal').modal 'show'
  return


$('body.transactions_new').ready ->
  setStock()

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
    $('#transaction_stock_num').val(Math.floor($('#transaction_fund').val()/$('#transaction_stock_price').val()))
    # Transaction money
    $('#transaction_fund').val($('#transaction_fund_original').val()/$('#transaction_exchange_rate').val())
    return
    
  $('#transaction_seller_id').change ->
    setStock()
    return

  $('#transaction_stock').change ->
    setCurrency()
    return

