# Excludes JS files from services which generates exceptions we can't help
isExcludedFile = (filename)->
  excludedServices = []
  excludedServices.push('newrelic', 'livechatinc')
  result = null

  $.each excludedServices, (index, value) ->
    result = filename.match(value)
    return if result

  result

# Subscribes to TraceKit and sends report via ExceptionNotification gem
TraceKit.report.subscribe JSExceptionNotifierLogger = (errorReport) ->

  if errorReport.message != "" and errorReport.stack[0].line > 0 and isExcludedFile(errorReport.stack[0].url) is null
    $.ajax
      url: '/js_exception_notifier'
      data : { errorReport }
      type : 'POST'
      dataType: 'script'
      error: (data, textStatus, jqXHR) ->
        alert data.responseText

# Wraps your code on document.ready
$.fn.ready = TraceKit.wrap($.fn.ready)