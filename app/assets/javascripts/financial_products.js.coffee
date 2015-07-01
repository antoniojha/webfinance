# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->

  $(".financial_product_name").autocomplete
  source: ["foo", "food", "bar"]
  $(".financial_product_name").html("test")