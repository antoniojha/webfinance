# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.best_in_place').best_in_place()

  $(document).tooltip
    items: "[title]",
    content:->
      $(this).attr("title")
      
  $('#financial_stories').click ->
    $(".financial_stories").show()
    $(".financial_testimonies").hide()
    return false
    
  $("#financial_testimonies").click ->
    $(".financial_stories").hide()
    $(".financial_testimonies").show()
    return false
  