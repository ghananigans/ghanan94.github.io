---
---
'use strict'

delegated = document.querySelector '.wrapper'

collapsibleClick = (event) ->
  target = event.target || event.srcElement
  
  while target? && target != delegated && !target.classList.contains 'collapsible-header'
    target = target.parentNode
    
  if !target? || target == delegated
    return
  
  content = target.parentNode.querySelector '.collapsible-content'
  
  if !content?
    return
  
  if content.style.display == 'none'
    content.style.display = 'block'
  else
    content.style.display = 'none'
  return


if delegated.addEventListener
  delegated.addEventListener 'click', collapsibleClick, false
else
  delegated.attachEvent 'onclick', collapsibleClick
    