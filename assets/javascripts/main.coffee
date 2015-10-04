---
---
'use strict'

loader = document.querySelector '.loader-wrapper'
head = document.head
body = document.body
  
navLinkClick = (event) ->
  event.preventDefault()
  srcElement = event.target || event.srcElement
  url = srcElement.getAttribute 'href'
  ajax {
    url: url,
    
    beforeSend: () ->
      loader.classList.add 'visible'
      return true
    
    success: (xmlhttp) -> 
      data = new DOMParser().parseFromString xmlhttp.responseText, "text/html"
      page = document.querySelector '.page-content-wrapper'
    
      pageContentSwap page, data
    
      srcElement.parentNode.classList.add 'active'
      history.pushState null, null, url  
      ga 'send', 'pageview'
      return
  }
  return


(()->
  navLinks = document.querySelectorAll '.header-links a'
  for navLink in navLinks
    if navLink.addEventListener
      # For all major browsers, except IE 8 and earlier
      navLink.addEventListener 'click', navLinkClick, true
    else if navLink.attachEvent
      # For IE 8 and earlier versions
      navLink.addEventListener 'onclick', navLinkClick
  return
).call this


window.onpopstate = (event) ->
  url = document.location
  ajax {
    url: url
    
    beforeSend: () ->
      loader.classList.add 'visible'
      return true
    
    success: (xmlhttp) -> 
      data = new DOMParser().parseFromString xmlhttp.responseText, "text/html"
      page = document.querySelector '.page-content-wrapper'
      pageContentSwap page, data
      navLinks = document.querySelectorAll '.header-links a'
      for navLink in navLinks
        if navLink.getAttribute('href') == window.location.pathname
          navLink.parentNode.classList.add 'active'
        else
          navLink.parentNode.classList.remove 'active'
      return 
      ga 'send', 'pageview'
  }
  return


pageContentSwap = (page, data) ->
  styleScriptsRemove = document.querySelectorAll 'script[data-ajax-keep="false"], link[data-ajax-keep="false"]'

  for el in styleScriptsRemove
    el.parentNode.removeChild el

  styles = data.querySelectorAll 'link[data-ajax-keep="false"]'
  scripts = data.querySelectorAll 'script[data-ajax-keep="false"]'

  for style in styles
    addStyle style

  page.innerHTML = data.querySelector('.page-content-wrapper').innerHTML

  for script in scripts
    addScript script

  navLinks = document.querySelectorAll '.header-links a'

  for navLink in navLinks
    navLink.parentNode.classList.remove 'active'

  loader.classList.remove 'visible'
  return


addStyle = (style) ->
  head.appendChild style
  return


addScript = (script) ->
  # evalScript script
  type      = script.getAttribute 'type'
  src       = script.getAttribute 'src'
  ajaxKeep  = script.dataset.ajaxKeep
  async     = script.async
  defer     = script.defer
  
  newScript       = document.createElement 'script'
  newScript.type  = type
  newScript.src   = src
  newScript.defer = defer
  newScript.async = async
  newScript.dataset.ajaxKeep = ajaxKeep

  body.appendChild newScript
  return


evalScript = (script) ->
  url = script.getAttribute('src')
  
  ajax {
    url: url
    
    success: (xmlhttp) -> 
      data = xmlhttp.responseText.toString()
      eval data
      return
  }
  return
  