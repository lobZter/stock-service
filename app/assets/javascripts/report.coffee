$('body.report_contract_report').ready ->

  $('tr[data-link]').click ->
    window.location = $(this).data('link')
    return
    
  return
  