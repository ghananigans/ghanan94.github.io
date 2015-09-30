---
---
'use strict';


root = exports ? this;

root.ajax = (options) ->
  settings = {
    url: '',
    data: null,
    method: 'get',
    async: true,
    beforeSend: -> return true,
    success: -> return,
    error: -> return
  }

  for option of options
    settings[option] = options[option]

  if window.XMLHttpRequest
    # code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp = new XMLHttpRequest
  else
    # code for IE6, IE5
    xmlhttp = new ActiveXObject('Microsoft.XMLHTTP')
    
  xmlhttp.onreadystatechange = ->
    if (xmlhttp.readyState == 4)
      if (xmlhttp.status == 200)
        settings.success xmlhttp
      else
        settings.error xmlhttp
    return
  
  if settings.beforeSend()
    xmlhttp.open settings.method, settings.url, settings.async

    if settings.method == 'post'
      xmlhttp.send settings.data
    else
      xmlhttp.send()
  
  return

