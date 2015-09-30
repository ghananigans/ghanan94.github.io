---
---
'use strict';


navLinkClick = (event) ->
  event.preventDefault()
  srcElement = event.target || event.srcElement
  url = srcElement.getAttribute 'href'
  ajax {
    url: url,
    success: (xmlhttp) -> 
      data = new DOMParser().parseFromString xmlhttp.responseText, "text/html"
      page = document.querySelector '.page-content-wrapper'
      page.innerHTML = data.querySelector('.page-content-wrapper').innerHTML
      navLinks = document.querySelectorAll '.header-links a'
      for navLink in navLinks
        navLink.parentNode.classList.remove 'active'
      srcElement.parentNode.classList.add 'active'
      history.pushState null, null, url
      return 
  }
  return


(()->
  navLinks = document.querySelectorAll '.header-links a'
  for navLink in navLinks
    navLink.addEventListener 'click', navLinkClick, true
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
  