# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $(".microposts").infinitescroll
    navSelector: "div.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "div.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: ".microposts li.micropost" # selector for all items you'll retrieve
    behavior: 'twitter'
  $('.more').click ->
    $(".microposts").infinitescroll('retrieve');