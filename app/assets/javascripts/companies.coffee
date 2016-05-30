# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$('body.companies_new').ready ->
  # Datetime picker format
  $('#datetimepicker1').datetimepicker({
     format: 'YYYY/MM/DD'
  });
  $('#datetimepicker2').datetimepicker({
     format: 'YYYY/MM/DD'
  });
  
  # Calculate stock num
  $('input.auto-calculate').change ->
    $('#company_stock_num').val  Math.floor($('#company_fund').val()/$('#company_stock_price').val())
    return

  $(".staff_select2").select2({theme: "bootstrap"})
  
  $(".remove_btn").click ->
    $(this).parent().remove()
    return