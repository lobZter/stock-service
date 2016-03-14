# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
setStockholderSearchUrl = ->
  url = 'stockholders/' + $('#stockholder_input').val()
  $('#stockholder_search_btn').attr 'href', url
  
setCompanySearchUrl = ->
  url = 'companies/' + $('#company_input').val()
  $('#company_search_btn').attr 'href', url

$('body.main_index').ready ->
  setStockholderSearchUrl()
  setCompanySearchUrl()
  
  $(".main_select2").select2({theme: "bootstrap"});
  
  $('#stockholder_input').change ->
    setStockholderSearchUrl()
    return

  $('#company_input').change ->
    setCompanySearchUrl()
    return