$('body.report_company_report').ready ->

  $('#report_datetimepicker1')
  .datetimepicker({
     format: 'YYYY/MM/DD'
  })
  
  $('#report_datetimepicker2')
  .datetimepicker({
     format: 'YYYY/MM/DD'
  })
    
  return
  
$('body.report_contract_report').ready ->

  $('tr[data-link]').click ->
    window.location = $(this).data('link')
    return
    
  return
  
$('body.report_company_report').ready ->

  $('tr[data-link]').click ->
    window.location = $(this).data('link')
    return
    
  return