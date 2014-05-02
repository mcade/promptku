# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  $(".microposts").infinitescroll
    navSelector: "div.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "div.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: ".microposts li.micropost" # selector for all items you'll retrieve
    behavior: 'twitter'
    animate: true
  , (newElements) ->
      $('li.micropost').each ->
        nlid = $(this).data('url')
        nlform = new NLForm(document.getElementById("post" + nlid))  if $("li#post" + nlid + " .nl-field-toggle").length is 0
        $ ->
          $("li#post" + nlid + " form input").keyup ->
            $("span#author" + nlid).hide()
            $("span#tags" + nlid).fadeIn()
            $("div.nl-submit-wrap#submit" + nlid).fadeIn()
        $("#btn" + nlid).click (event) ->
          kutext = $("li#post" + nlid + " span.content").data('url')
          $("span#author" + nlid).slideDown()
          $("span#tags" + nlid).slideUp()
          $("div.nl-submit-wrap#submit" + nlid).fadeOut 1300, ->
            $("#post" + nlid + " a.nl-field-toggle").text kutext
            if $("button.more").length isnt 0
              $("li.micropost").last().slideUp "slow", ->
                $("li.micropost").last().remove()
        $ ->
          $("i#clicker" + nlid).click ->
            SelectText "selectme" + nlid
        seen = {}
        $("li#post" + nlid + " .nl-field").each ->
          txt = $(this).text()
          if seen[txt]
            $(this).remove()
          else
            seen[txt] = true
        $('li.micropost').attr('class', 'micropos');
        return





  $('.more').click ->
    $(".microposts").infinitescroll('retrieve');
$(document).ready ->
  $('li.micropost').each ->
          nlid = $(this).data('url')
          nlform = new NLForm(document.getElementById("post" + nlid))  if $("li#post" + nlid + " .nl-field-toggle").length is 0
          $ ->
            $("li#post" + nlid + " form input").keyup ->
              $("span#author" + nlid).hide()
              $("span#tags" + nlid).fadeIn()
              $("div.nl-submit-wrap#submit" + nlid).fadeIn()
          $("#btn" + nlid).click (event) ->
            kutext = $("li#post" + nlid + " span.content").data('url')
            $("span#author" + nlid).slideDown()
            $("span#tags" + nlid).slideUp()
            $("div.nl-submit-wrap#submit" + nlid).fadeOut 1300, ->
              $("#post" + nlid + " a.nl-field-toggle").text kutext
              if $("button.more").length isnt 0
                $("li.micropost").last().slideUp "slow", ->
                  $("li.micropost").last().remove()
          $ ->
            $("i#clicker" + nlid).click ->
              SelectText "selectme" + nlid
          $("li#post" + nlid + " div.nl-field:nth-child(2)").remove() if $("li#post" + nlid + " .nl-field-toggle").length is 2
          return