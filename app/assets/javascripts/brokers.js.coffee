# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $("#financial_vehicles .fin_product").tooltip
    items: "span",
    content: ->
      element = $(this)     
      "<div style='text-align:left;'> Company: "+element.attr("title")+"<br>Description: "+element.attr("alt")+"</div>"
        
  update_profile = (form)->
    formData=form.serialize()
    $.ajax
      url: form.attr("action"),
      type: "POST",
      dataType: "script",
      data: formData,
      error: (jqXHR, textStatus, errorThrown)->
        console.log(textStatus, errorThrown)
      ,
      success: (data) ->
        console.log( "ajax was successfully performed." )
  
  edit_profile = (edit_url, object) ->
    if object=="fin_product"
      edit_form="form.fin_product_edit_form"
      delete_form="form.delete_fin_product_form"
    else if object=="education"
      edit_form="form.education_edit_form"
      delete_form="form.delete_education_form" 
    else if object=="experience"  
      edit_form="form.experience_edit_form"
      delete_form="form.delete_experience_form" 
    else if object="financial_story"
      edit_form="form.fin_story_edit_form"
      delete_form="form.delete_fin_story_form"         
    $.ajax
      url: edit_url,
      type: "GET",
      dataType: "script",    
      error: (jqXHR, textStatus, errorThrown)->
        console.log(textStatus, errorThrown)
      ,
      success: (data) ->
        console.log( "ajax was successfully performed.")  
        $(edit_form).submit (event)->
          event.preventDefault()
          update_profile($(this))    
        $(delete_form).click (event)->
          event.preventDefault()
          ans=confirm("Are you sure?")
          action=$(this).attr("action")

          if ans  
            $.ajax
              url: action,
              type: "POST",
              dataType: "script",
              data: {"_method":"delete"},
              error: (jqXHR, textStatus, errorThrown)->
                console.log(textStatus, errorThrown)
              ,
              success: (data) ->
                console.log( "ajax was successfully performed.")    
  
  $("#profile_infos").on "click","a.profile_info_edit", ->
    if $(".profile_info_form").is(':visible')
      $(".profile_info_form").hide()
      $(".profile_info_display").show()
    else
      $(".profile_info_form").show()
      $(".profile_info_display").hide()
  
  $("#profile_infos").on "submit","form#profile_info_form", (event)->
    event.preventDefault()
    update_profile($(this))
      
  $("#abouts").on "click","a.about_edit", ->
    if $(".about_form").is(':visible')
      $(".about_form").hide()
      $(".about_display").show()
    else
      $(".about_form").show()
      $(".about_display").hide() 
      
  $("#abouts").on "submit","form#about_form",(event)->
    event.preventDefault()
    update_profile($(this))       
  
  $("#skills").on "click", "a.skills_edit", ->
    if $(".skills_form").is(':visible')
      $(".skills_form").hide()
      $(".skills_display").show()
    else
      $(".skills_form").show()
      $(".skills_display").hide()
      
  $("#skills").on "submit","form#skills_form",(event)->
    event.preventDefault()
    update_profile($(this))  

  $("#license_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 700
 
  $("#licenses").on "click","a.licenses_edit", ->
    $("#license_dialog_form").dialog("open")
  
  $("#financial_vehicles").on "click","a.financial_vehicle_edit", ->
    $("#financial_vehicle_dialog_form").dialog("open")  
    
  $("#financial_vehicle_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 600,    
    height: 600
    
  $("#financial_vehicle_dialog_form").on "submit","form#vehicle_form",(event)->
    event.preventDefault()
    update_profile($(this))  
    
  $("#fin_product_add_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 400,        
  # clicking Add Product link to display form to add product.  
  $("#financial_vehicles").on "click", "a.fin_product_add", ->
    $("#fin_product_add_dialog_form").dialog("open")  
    
  $("#fin_product_add_dialog_form").on "submit","form#fin_product_add_form", (event)->
    event.preventDefault()
    update_profile($(this))    
    
  $("#fin_product_edit_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 400
    
  $("#financial_vehicles").on "click","a.fin_product_edit", -> 
    id=$(this).attr("id")
    edit_url="/financial_products/"+id+"/edit"
    edit_profile(edit_url, "fin_product")
                
  $("#education_add_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 500        
    
  $("#educations").on "click", "a.education_add", ->
    $("#education_add_dialog_form").dialog("open") 
    
  $("#education_add_dialog_form").on "submit","form#education_add_form", (event)->
    event.preventDefault()
    update_profile($(this))     

  $("#education_edit_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 400    
    
  $("#educations").on "click","a.education_edit", -> 
    id=$(this).attr("id")
    edit_url="/educations/"+id+"/edit"
    edit_profile(edit_url, "education")       
    
  $("#experience_add_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 500        
    
  $("#experiences").on "click", "a.experience_add", ->
    $("#experience_add_dialog_form").dialog("open")  
    
  $("#experience_add_dialog_form").on "submit","form#experience_add_form", (event)->
    event.preventDefault()
    update_profile($(this))      
    
  $("#experience_edit_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 400    
        
  $("#experiences").on "click","a.experience_edit", -> 
    id=$(this).attr("id")
    edit_url="/experiences/"+id+"/edit"
    edit_profile(edit_url, "experience")      

  $("#fin_story_add_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 700        
    
  $("#financial_stories").on "click", "a.financial_story_add", ->
    $("#fin_story_add_dialog_form").dialog("open")    
    
  $("#fin_story_add_dialog_form").on "submit","form#fin_story_add_form", (event)->
    event.preventDefault()
    update_profile($(this))       
    
  $("#fin_story_edit_dialog_form").dialog
    modal:true,
    autoOpen:false,
    width: 700    
      
  $("#financial_stories").on "click","a.fin_story_edit", -> 
    id=$(this).attr("id")
    edit_url="/financial_stories/"+id+"/edit"
    edit_profile(edit_url, "financial_story")      