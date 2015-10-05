# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#submit_broker_registration").submit (event) ->
    ans=confirm("Are you sure you want to submit?\n It will take 1-3 days to process your application.")
    if !ans
      event.preventDefault()
      
  $("#log_out").click (event) ->
    ans=confirm("Are you sure?\n You can come back to your application by signing in through login page.")
    if !ans
      event.preventDefault()
      event.stopImmediatePropagation()
      
      
  $("#broker_register_dialog").dialog(
      autoOpen: false,
      modal: true,
      buttons :
        "Yes" : ->
          $("#submit_broker_registration").submit()
        "Cancel" : ->
          $(this).dialog("close")
  )    
  