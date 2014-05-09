# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $(".microposts").infinitescroll
    navSelector: "div.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "div.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: ".microposts li.micropost" # selector for all items you'll retrieve
    behavior: 'twitter'
  , (newElements) ->
      $( "#infscr-loading ~ li" ).each ->
        nlid = $(this).data('url')
        nlform = new NLForm(document.getElementById "post" + nlid )
        $ ->
          $("#post" + nlid + " form input").keyup ->
            $("#author" + nlid).hide()
            $("#tags" + nlid).fadeIn()
            $("#submit" + nlid).fadeIn()
        $("#btn" + nlid).click (event) ->
          kutext = $("#post" + nlid + " span.content").data('url')
          $("#author" + nlid).slideDown()
          $("#tags" + nlid).slideUp()
          $("#submit" + nlid).fadeOut 1300, ->
            $("#post" + nlid + " a.nl-field-toggle").text kutext
            if $("button.more").length isnt 0
              $("li.micropost").last().slideUp "slow", ->
                $("li.micropost").last().remove()
        $ ->
        return





  $('.more').click ->
    $(".microposts").infinitescroll('retrieve');
$(document).ready ->
  $('li.micropost').each ->
          nlid = $(this).data('url')
          nlform = new NLForm(document.getElementById("post" + nlid))  if $("#post" + nlid + " .nl-field-toggle").length is 0
          $ ->
            $("#post" + nlid + " form input").keyup ->
              $("#author" + nlid).hide()
              $("#tags" + nlid).fadeIn()
              $("#submit" + nlid).fadeIn()
          $("#btn" + nlid).click (event) ->
            kutext = $("#post" + nlid + " span.content").data('url')
            $("#author" + nlid).slideDown()
            $("#tags" + nlid).slideUp()
            $("#submit" + nlid).fadeOut 1300, ->
              $("#post" + nlid + " a.nl-field-toggle").text kutext
              if $("button.more").length isnt 0
                $("li.micropost").last().slideUp "slow", ->
                  $("li.micropost").last().remove()
          $ ->
          return