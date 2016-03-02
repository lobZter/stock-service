# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  
  $('#stockholder_input').change ->
    val = $('#stockholder_input').val()
    url = 'stockholders/' + $('#stockholder_list [value="' + val + '"]').data('value')
    $('#stockholder_search_btn').attr 'href', url
    return


  $('#company_input').change ->
    val = $('#company_input').val()
    url = 'companies/' + $('#company_list [value="' + val + '"]').data('value')
    $('#company_search_btn').attr 'href', url
    return
