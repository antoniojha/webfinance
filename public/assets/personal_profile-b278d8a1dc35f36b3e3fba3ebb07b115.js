$(function(){
  $(".financial_product_name").autocomplete({
    source: $(".financial_product_name").data('autocomplete-source')
  });

   var picture_file_name=$('#picture_form').data('picture-file-name');
   var crop=$('#picture_form').data('crop');
   if (picture_file_name!="null"){ 

      var pic_large_width=parseInt($('#picture_form').data('broker-pic-large-width'));
      var pic_large_height=parseInt($('#picture_form').data('broker-pic-large-height'));
      var pic_orig_width=parseInt($('#picture_form').data('broker-pic-orig-width'));

      var x=pic_large_width/2+100;
      var y=pic_large_height/2+100;
       
      $('#cropbox').Jcrop({
        onChange: update_crop,
        onSelect: update_crop,
        setSelect: [x, y, 100,100],
          aspectRatio: 1
        });
  
      function update_crop(coords) {
        var rx = 100/coords.w;
        var ry = 100/coords.h;
        $('#preview').css({
          width: Math.round(rx * pic_large_width) + 'px',
          height: Math.round(ry * pic_large_height) + 'px',
          marginLeft: '-' + Math.round(rx * coords.x) + 'px',
          marginTop: '-' + Math.round(ry * coords.y) + 'px'
        });
        var ratio = pic_orig_width/pic_large_width;       
        $('#crop_x').val(Math.floor(coords.x * ratio));
        $('#crop_y').val(Math.floor(coords.y * ratio));
        $('#crop_w').val(Math.floor(coords.w * ratio));
        $('#crop_h').val(Math.floor(coords.h * ratio));   
      };
   }
  
  create_financial_dialog = $( "#financial_story_form" ).dialog({
    autoOpen: false,
    height: 550,
    width: 800,
    modal: true
  });
  
  if((picture_file_name!="null") && (crop!="true")){
    alert("test1");
    change_dialog = $( "#change_dialog-form" ).dialog({
      autoOpen: false,
      height: 550,
      width: 800,
      modal: true
    });
  }
  else if((picture_file_name!="null") && (crop=="true")){
    alert("test2");
    upload_dialog = $( "#upload_dialog-form" ).dialog({
      autoOpen: true,
      height: 550,
      width: 800,
      modal: true
    });    
  }
  else{
 
    upload_dialog = $( "#upload_dialog-form" ).dialog({
      autoOpen: false,
      height: 550,
      width: 800,
      modal: true
    });
  }
  $( ".change-btn" ).button().on( "click", function() {
  //  alert("it's working");
    change_dialog.dialog( "open" );
  });
  $( ".upload-btn" ).button().on( "click", function() {
  //  alert("it's working");
    upload_dialog.dialog("open");
  });
  $(".create_finance_story").on("click",function(){
    create_financial_dialog.dialog("open");
  });
});
