# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  save_story_form = $( "#save_story_form" ).dialog
    autoOpen: false,
    height: 400,
    width: 700,
    modal: true
    
  $( "#save_story" ).button().on "click", ->
     save_story_form.dialog( "open" )