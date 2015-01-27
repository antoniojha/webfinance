// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
ready=function(){
  $("#drop-down1").click(function(){
    isClicked=$(this).data('clicked');
    if(isClicked) {isClicked=false;} else {isClicked=true;}
    $(this).data('clicked',isClicked);

    if (isClicked){
          $(this).find("img").attr("src","/assets/glyphicons-601-chevron-up.png");
          $("#panel1").show();
        }
    else{
          $(this).find("img").attr("src","/assets/glyphicons-602-chevron-down.png");
          $("#panel1").hide();                     
      }
  });
  $("#drop-down2").click(function(){
    isClicked=$(this).data('clicked');
    if(isClicked) {isClicked=false;} else {isClicked=true;}
    $(this).data('clicked',isClicked);

    if (isClicked){
          $(this).find("img").attr("src","/assets/glyphicons-601-chevron-up.png");
          $("#panel2").show();
        }
    else{
          $(this).find("img").attr("src","/assets/glyphicons-602-chevron-down.png");
          $("#panel2").hide();                     
      }
  });
  $("#drop-down3").click(function(){
    isClicked=$(this).data('clicked');
    if(isClicked) {isClicked=false;} else {isClicked=true;}
    $(this).data('clicked',isClicked);

    if (isClicked){
          $(this).find("img").attr("src","/assets/glyphicons-601-chevron-up.png");
          $("#panel3").show();
        }
    else{
          $(this).find("img").attr("src","/assets/glyphicons-602-chevron-down.png");
          $("#panel3").hide();                     
      }
  });
  $("#drop-down4").click(function(){
    isClicked=$(this).data('clicked');
    if(isClicked) {isClicked=false;} else {isClicked=true;}
    $(this).data('clicked',isClicked);

    if (isClicked){
          $(this).find("img").attr("src","/assets/glyphicons-601-chevron-up.png");
          $("#panel4").show();
        }
    else{
          $(this).find("img").attr("src","/assets/glyphicons-602-chevron-down.png");
          $("#panel4").hide();                     
      }
  });  
  $(".protection_need").blur(function(){ 
    display_sum();
  });
  var array=[];
  $(".protection_need").each(function() {
    array.push(parseFloat($(this).val()).toFixed(2));
  });
 // alert(array.join('\n'));
  $("#reset").click(function(){
    var i=0;
    $(".protection_need").each(function() {
      $(this).attr("value",array[i]);
      i++;
    });
    display_sum();
  });
  function display_sum(){
    var total=0;
    $(".protection_need").each(function() {
      total=total+parseFloat($(this).val());
    });
    total=total.toFixed(2);
    total=Intl.NumberFormat().format(total);
    if (typeof total.split(".")[1]==='undefined')
    {
         total=total+".00";
    }
    $("#total").text("$"+total);
  };
};

$(document).ready(ready);