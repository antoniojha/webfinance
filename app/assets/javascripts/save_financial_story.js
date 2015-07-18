$(function(){
  var error=$('#save_story_form').data('error');
  if (error==true){
   save_story_dialog = $( "#save_story_dialog-form" ).dialog({
      autoOpen: true,
      height: 550,
      width: 500,
      modal: true  
    });    
  }
  else{
   save_story_dialog = $( "#save_story_dialog-form" ).dialog({
      autoOpen: false,
      height: 550,
      width: 500,
      modal: true  
    });
  }
  $( "#save_story" ).button().on( "click", function() {
     save_story_dialog.dialog( "open" );    
  }); 
});