$(function(){

   var picture_file_name=$('#picture_form').data('picture-file-name');
   var crop=$('#picture_form').data('crop');
  
   if (picture_file_name!="null"){ 
      var pic_large_width=$('#cropbox').width();
      var pic_large_height=$('#cropbox').height();
     console.log("width:"+pic_large_width);
     console.log("height:"+pic_large_height);
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
        var width=$('#preview').css("width");
      
        $('#preview').css({
          width: Math.round(rx * pic_large_width) + 'px',
          height: Math.round(ry * pic_large_height) + 'px',
          marginLeft: '-' + Math.round(rx * coords.x) + 'px',
          marginTop: '-' + Math.round(ry * coords.y) + 'px'
        }); 
        if ($('#broker_crop_x').length){
        $('#broker_crop_x').val(Math.floor(coords.x));
        $('#broker_crop_y').val(Math.floor(coords.y));
        $('#broker_crop_w').val(Math.floor(coords.w));
        $('#broker_crop_h').val(Math.floor(coords.h));
        }
        else if($('#user_crop_x').length){
        $('#user_crop_x').val(Math.floor(coords.x));
        $('#user_crop_y').val(Math.floor(coords.y));
        $('#user_crop_w').val(Math.floor(coords.w));
        $('#user_crop_h').val(Math.floor(coords.h));          
        }
       console.log("crop_x:"+Math.floor(coords.x));
       console.log("crop_y:"+Math.floor(coords.y));
       console.log("crop_w:"+Math.floor(coords.w));
       console.log("crop_h:"+Math.floor(coords.h));
      };
   }
  
  console.log("crop:"+crop);
  console.log("picture file name:"+picture_file_name);
  //three cases for loading dialog form: 1- Load modal form to crop picture when it's first open; 2- Immediately load modal form to show cropped picture after picture is loaded; 3- Load modal form to upload picture when no picture has been uploaded.
  if((typeof picture_file_name!="undefined") && (crop!=true)){
    change_dialog = $( "#change_dialog-form" ).dialog({
      autoOpen: false,
      height: 500,
      width: 700,
      modal: true
      
    });
  }
  else if((typeof picture_file_name!="undefined") && (crop==true)){
    change_dialog = $( "#change_dialog-form" ).dialog({
      autoOpen: true,
      height: 500,
      width: 700,
      modal: true
    });  
  }
  else{
    upload_dialog = $( "#upload_dialog-form" ).dialog({
      autoOpen: false,
      height: 500,
      width: 700,
      modal: true
    });
  }
  $( ".btn-change" ).button().on( "click", function() {
     change_dialog.dialog( "open" );    
  });
  $( ".btn-upload" ).button().on( "click", function() {    
      upload_dialog.dialog("open");
  });
});
