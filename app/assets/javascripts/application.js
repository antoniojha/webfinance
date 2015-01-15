// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require add_association
//= require remove_association
//= require pagination
//= raphael
//= require_tree .


ready=function(){
//   $('#bank_login').validate();
  //**important- $field will be used in controller/backgrounds/add_assoc.js.erb
 
  if ($('#bank_login').length>0){
  $('#bank_login').validate({
    rules: {
      LOGIN: {
        required:true
      },
      PASSWORD:{
        required:true
      }
    },
    messages: {
      LOGIN:{
        required: "Please specify your name"
      },
      PASSWORD:{
        required: "Please enter password"                    
      }
    }
  });
  }
  if ($('new_user').length>0){
  $('#new_user').validate({
    rules: {
      user_username:{
        required:true
      }
    },
    messages: {
      user_username:{
        required: "Please specify your name"
      }
    }
  });
  }
  // initiates map jquery
  $('#map').usmap({});
}
$(document).ready(ready);