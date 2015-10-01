---
---
'use strict'

collapsibleClick = (event) ->
  header = event.currentTarget
  content = header.parentNode.querySelector '.collapsible-content'
  
  if content.style.display == 'none'
    content.style.display = 'block'
  else
    content.style.display = 'none'
  return

collapsibles = document.querySelectorAll '.collapsible'

for collapsible in collapsibles
  header = collapsible.querySelector '.collapsible-header'
  
  if header.addEventListener
    header.addEventListener 'click', collapsibleClick, false
  else
    header.attachEvent 'onclick', collapsibleClick
    