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
  
setView = () ->
  query = location.search.substr(1)
  result = {}
  query.split('&').forEach (part) ->
    if part != ''
      item = part.split('=')
      result[item[0]] = decodeURIComponent(item[1])
    return
    
  if result["buyer_id"] != undefined
    $('#buyer_filter_input').val(result.buyer_id)
  if result["seller_id"] != undefined
    $('#seller_filter_input').val(result.seller_id)
  if result["company_id"] != undefined && result["stock_class"] != undefined && result["date_issued"] != undefined
    stock_option = '{\'company_id\': \'' + result.company_id + '\', \'stock_class\': \'' + result.stock_class + '\', \'date_issued\': \'' + result.date_issued + '\'}'
    $('#stock_filter_input').val(stock_option)
  
  if (result["set_all"] == undefined && result["set_completed"] == undefined && result["set_not_completed"] == undefined) || result["set_all"] != undefined
    $('#set_all').addClass("active")
    $('#set_completed').removeClass("active")
    $('#set_not_completed').removeClass("active")
  if result["set_completed"] != undefined
    $('#set_all').removeClass("active")
    $('#set_completed').addClass("active")
    $('#set_not_completed').removeClass("active")
  if result["set_not_completed"] != undefined
    $('#set_all').removeClass("active")
    $('#set_completed').removeClass("active")
    $('#set_not_completed').addClass("active")
  return
  
setTransactionFilterUrl = () -> 
  url = 'transactions?'
  if $('#buyer_filter_input').val() != '0'
    url += '&buyer_id=' + $('#buyer_filter_input').val()
  if $('#seller_filter_input').val() != '0'
    url += '&seller_id=' + $('#seller_filter_input').val()
  if $('#stock_filter_input').val() != '0'
    stock = JSON.parse($('#stock_filter_input').val().replace(/'/g, '"'))
    url += '&company_id=' + stock.company_id + '&stock_class=' + stock.stock_class + '&date_issued=' + stock.date_issued
  
  $('#filter_btn').attr 'href', url
  $('#set_all').attr 'href', url + '&set_all=1'
  $('#set_completed').attr 'href', url + '&set_completed=1'
  $('#set_not_completed').attr 'href', url + '&set_not_completed=1'
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
  setView()
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

  $(".transaction_index_select2").select2({theme: "bootstrap"});
  
  return
