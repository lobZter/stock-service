set_field = "set_all"

setView = () ->
  query = location.search.substr(1)
  result = {}
  query.split('&').forEach (part) ->
    if part != ''
      item = part.split('=')
      result[decodeURIComponent(item[0])] = decodeURIComponent(item[1])
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


$ ->
  
  if $('#transactions_index').is(':visible')
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
    
  $(".bootstrap_select2").select2({theme: "bootstrap"});
    
  return
