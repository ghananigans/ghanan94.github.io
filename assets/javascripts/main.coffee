---
---
'use strict'

loader = document.querySelector '.loader-wrapper'

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
  }
  return


pageContentSwap = (page, data) ->
  styleScriptsRemove = document.querySelectorAll 'script[data-ajax-keep="false"], link[data-ajax-keep="false"]'

  for el in styleScriptsRemove
    el.parentNode.removeChild el

  styleAdd = data.querySelectorAll 'link[data-ajax-keep="false"]'
  scriptAdd = data.querySelectorAll 'script[data-ajax-keep="false"]'
  head = document.head
  body = document.body

  for style in styleAdd
    head.appendChild style

  page.innerHTML = data.querySelector('.page-content-wrapper').innerHTML

  for script in scriptAdd
    evalScript script
    body.appendChild script

  navLinks = document.querySelectorAll '.header-links a'

  for navLink in navLinks
    navLink.parentNode.classList.remove 'active'

  loader.classList.remove 'visible'
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
  