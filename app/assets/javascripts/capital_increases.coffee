# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  # Datetime picker format
  $('#capital_increases_datetimepicker1').datetimepicker({
     format: 'YYYY/MM/DD'
  });

  # Calculate 
  $('input.auto-calculate').change ->
    # Stock number
    $('#capital_increase_stock_num').val($('#capital_increase_fund').val()/$('#capital_increase_stock_price').val())
    return
