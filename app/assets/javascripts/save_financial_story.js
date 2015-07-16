$(function(){
   save_story_dialog = $( "#save_story_dialog-form" ).dialog({
      autoOpen: false,
      height: 550,
      width: 500,
      modal: true  
    });
  $( "#save_story" ).button().on( "click", function() {
     save_story_dialog.dialog( "open" );    
  }); 
});