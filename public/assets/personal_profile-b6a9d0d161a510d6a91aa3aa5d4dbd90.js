$(function(){
  $(".financial_product_name").autocomplete({
    source: $(".financial_product_name").data('autocomplete-source')
  });

   var picture_file_name=$('#picture_form').data('picture-file-name');
   var crop=$('#picture_form').data('crop');
  
   if (picture_file_name!="null"){ 

  //    var pic_large_width=parseInt($('#picture_form').data('broker-pic-large-width'));
  //    var pic_large_height=parseInt($('#picture_form').data('broker-pic-large-height'));
      var pic_large_width=$('#cropbox').width();
      var pic_large_height=$('#cropbox').height();
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
        $('#broker_crop_x').val(Math.floor(coords.x));
        $('#broker_crop_y').val(Math.floor(coords.y));
        $('#broker_crop_w').val(Math.floor(coords.w));
        $('#broker_crop_h').val(Math.floor(coords.h));   
      };
   }
  

  if((typeof picture_file_name!="undefined") && (crop!=true)){
    change_dialog = $( "#change_dialog-form" ).dialog({
      autoOpen: false,
      height: 550,
      width: 800,
      modal: true
    });
  }
  else if((typeof picture_file_name!="undefined") && (crop==true)){
    change_dialog = $( "#change_dialog-form" ).dialog({
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
  $( ".btn-change" ).button().on( "click", function() {
     change_dialog.dialog( "open" );    
  });
  $( ".btn-upload" ).button().on( "click", function() {    
      upload_dialog.dialog("open");
  });
  create_financial_dialog = $( "#create_story_form" ).dialog({
    autoOpen: false,
    height: 550,
    width: 800,
    modal: true
  });
  $(".create_finance_story").on("click",function(){

    create_financial_dialog.dialog("open");
  });
});
