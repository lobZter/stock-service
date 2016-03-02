# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  # Datetime picker format
  $('#datetimepicker1').datetimepicker({
     format: 'YYYY/MM/DD'
  });
  $('#datetimepicker2').datetimepicker({
     format: 'YYYY/MM/DD'
  });
  
  # Calculate stock num
  $('input.auto-calculate').change ->
    $('#company_stock_num').val $('#company_fund').val()/$('#company_stock_price').val()
    return
