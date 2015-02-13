// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
ready=function(){

  $("#check_all_life").click(function(){

    if(this.checked){
      $(".check_life").each(function(){
        this.checked=true;
      });
    }
    else{
      $(".check_life").each(function(){
        this.checked=false;
      });      
    }
  });
  // changes glyphicon up and down icon for drop down
  $(".drop-down").click(function(){
    $img=$(this).find("img");
    if ($img.attr("src")=="/assets/glyphicons-601-chevron-up.png"){
      $img.attr("src","/assets/glyphicons-602-chevron-down.png");
    }
    else{
      $img.attr("src","/assets/glyphicons-601-chevron-up.png"); 
    } 
  });
  $(".next").click(function(){

      $q=$(this).closest("div");
      $q.hide();
      $q_next=$q.next();
      $q_next.show(); 
  });
  $(".previous").click(function(){

      $q=$(this).closest("div");
      $q.hide();
      $q_prev=$q.prev();
      $q_prev.show(); 
  });
  $("#start").click(function(){
    $("#explanation").hide();
    $("#question").show();
    $("#start").hide();
  });
  $("#submit").click(function(){
    function getMaxOfArray(numArray) {
      return Math.max.apply(null, numArray);
    } 
    var w_life=0;
    var v_life=0;
    var vu_life=0;
    var u_life=0;
    var ui_life=0;
    var t_life=0;

    for(i=0;i<5;i++){
      var a1;
      var a2;
      var a3;
      var a4;
      var a5;
      a1=a2=a3=a4=a5=null;
      if(i===0){
        a1=$("[name=question_1]:checked").val();  
      }
      else if (i==1){
        a2=$("[name=question_2]:checked").val(); 
      }
      else if (i==2){
        a3=$("[name=question_3]:checked").val(); 
      }
      else if (i==3){
        a4=$("[name=question_4]:checked").val();  
      }
      else if (i==4){
        a5=$("[name=question_5]:checked").val();  
      }
      
      if ((a1==3) || (a2==1) || (a3==1) || (a4==1) || (a5==3) ){
        w_life++;
      }
      if ((a1==1) || (a2==1) || (a3==2) || (a4==2) || (a5==1)){
        v_life++;
      }
      if ((a1==1) || (a2==2) || (a3==2) || (a4==2) || (a5==1)){
        vu_life++;
      }
      if ((a1==3) || (a2==2) || (a3==1) || (a4==3) || (a5==2)){
        u_life++;
        ui_life++;
      }
      if ((a1==2) || (a2==2)|| (a3==3)||(a4==4)||(a5==3)){
        t_life++;      
      }
    }
    var w_obj={name:"whole life",value:w_life};
    var v_obj={name:"variable life", value:v_life};
    var vu_obj={name:"variable universal life", value:vu_life};
    var u_obj={name:"universal life", value:u_life};
    var ui_obj={name:"universal index life", value:ui_life};
    var t_obj={name:"term life", value:t_life};

    array=[w_obj, v_obj, vu_obj,u_obj,ui_obj,t_obj];

    array=array.sort(function(obj1, obj2){return obj2.value-obj1.value;});
    var max1=array[0];
    var max2=array[1];
    var name;
    if (max1.value==max2.value){
      name=max1.name+" & "+max2.name;
    }
    else{
      name=max1.name;
    }
    $("#start").show();
    $("#question1").show();
    $("#question1").find("input[value='1']").prop('checked','checked');
     // reset all the questions
    $(".question").each(function(){
      $(this).hide();
      $(this).find("input[value='1']").prop('checked','checked');
    });
    $("#question").hide();
    $("#explanation").show();
    $("#explanation").html("We recommends "+name);
  });
};
$(document).ready(ready);
$(document).on('page:load',ready);