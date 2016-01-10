---
---

sum = (list) -> list.reduce (a, e) -> a + e

ancestors = (node) -> if node then ancestors(node.parentNode).concat(node) else []

# get node coordinates
top = (node) -> sum(n.offsetTop or 0 for n in ancestors node)
left = (node) -> sum(n.offsetLeft or 0 for n in ancestors node)
right = (node) -> window.innerWidth - list.clientWidth - left list

scrollRight = (node) -> node.scrollWidth - node.clientWidth - node.scrollLeft

listIndicators = []
# make sure to call this if you create an event list dynamically
addIndicator = (list) ->

  indicators = for dir in ["left", "right"]
    indicator = document.createElement "div"
    indicator.setAttribute "class", "event-list-overflow-indicator #{dir}"
    document.body.appendChild indicator
    indicator

  [leftIndicator, rightIndicator] = indicators

  do resizeIndicators = ->
    leftIndicator.style.maxWidth = "#{list.scrollLeft}px"
    rightIndicator.style.maxWidth = "#{scrollRight list}px"

  list.addEventListener "scroll", resizeIndicators

  listIndicators.push [list, indicators]

addIndicator list for list in document.getElementsByClassName "event-list"

do layoutIndicators = ->
  for [list, indicators] in listIndicators
    for indicator in indicators
      indicator.style.top = "#{top list}px"
      indicator.style.height = "#{list.clientHeight}px"

    [leftIndicator, rightIndicator] = indicators

    leftIndicator.style.left = "#{left(list) - 1}px" # -1 for firefox
    rightIndicator.style.right = "#{right(list) - 1}px" # +1 for chrome

window.addEventListener "resize", layoutIndicators
