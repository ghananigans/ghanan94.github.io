---
---
'use strict';

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
      page.innerHTML = data.querySelector('.page-content-wrapper').innerHTML
      navLinks = document.querySelectorAll '.header-links a'
      for navLink in navLinks
        navLink.parentNode.classList.remove 'active'
      srcElement.parentNode.classList.add 'active'
      history.pushState null, null, url
      loader.classList.remove 'visible'
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
    url: url,
    success: (xmlhttp) -> 
      data = new DOMParser().parseFromString xmlhttp.responseText, "text/html"
      page = document.querySelector '.page-content-wrapper'
      page.innerHTML = data.querySelector('.page-content-wrapper').innerHTML
      navLinks = document.querySelectorAll '.header-links a'
      for navLink in navLinks
        if navLink.getAttribute('href') == window.location.pathname
          navLink.parentNode.classList.add 'active'
        else
          navLink.parentNode.classList.remove 'active'
      return 
  }
  return
  