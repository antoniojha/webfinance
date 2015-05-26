$(function(){

  change_dialog = $( "#change_dialog-form" ).dialog({
    autoOpen: false,
    height: 550,
    width: 800,
    modal: true
  });

  upload_dialog = $( "#upload_dialog-form" ).dialog({
    autoOpen: false,
    height: 550,
    width: 800,
    modal: true
  });    

  $( ".change-btn" ).button().on( "click", function() {
  //  alert("it's working");
    change_dialog.dialog( "open" );
  });
  $( ".upload-btn" ).button().on( "click", function() {
  //  alert("it's working");
    upload_dialog.dialog( "open" );
  });

});