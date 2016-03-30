currency = 
  1: 'USD'
  2: 'RMB'
  3: 'NTD'
  
stocks = undefined
set_field = "set_all"

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

@setModal = (image) ->
  $('#enlarge_image').attr 'src', image.src
  $('#image_modal').modal 'show'
  return
  
setTransactionFilterUrl = () -> 
  url = 'transactions?'
  url += 'buyer_id=' + $('#buyer_filter_input').val()
  url += '&seller_id=' + $('#seller_filter_input').val()
  stock = JSON.parse($('#stock_filter_input').val().replace(/'/g, '"'))
  url += '&company_id=' + stock.company_id + '&stock_class=' + stock.stock_class + '&date_issued=' + stock.date_issued
  url += "&" + set_field + "=1"
  
  $('#filter_btn').attr 'href', url
  return


$('body.transactions_new').ready ->
  setStock()
  
  $(".transaction_select2").select2({theme: "bootstrap"});
  
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

  $('.calculate-fund').change ->
    $('#transaction_fund').val($('#transaction_fund_original').val()/$('#transaction_exchange_rate').val())
    return
   
  $('.calculate-stocknum').change ->
    $('#transaction_stock_num').val(Math.floor($('#transaction_fund').val()/$('#transaction_stock_price').val()))
    return
 
  $('#transaction_seller_id').change ->
    setStock()
    return

  $('#transaction_stock').change ->
    setCurrency()
    return

  return
  
  
$('body.transactions_index').ready ->
  setTransactionFilterUrl()
  
  $('#buyer_filter_input').change ->
    setTransactionFilterUrl()
    return
  
  $('#seller_filter_input').change ->
    setTransactionFilterUrl()
    return
  
  $('#stock_filter_input').change ->
    setTransactionFilterUrl()
    return
    
  $('input:radio[name="set_field"]').change ->
    set_field = $(this).val()
    setTransactionFilterUrl()
    return

  $(".transaction_index_select2").select2({theme: "bootstrap"});
  
  return
