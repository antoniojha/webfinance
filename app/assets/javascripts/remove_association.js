$(function(){
  $(document).delegate(".remove_association","click", function(){
      $tbody=$(this).closest("tbody");
      $tbody.slideUp();
   
      $tbody.find("input[type='hidden']").attr("value",true);
    //  alert($tbody.find("input[type='hidden']").attr("value"));     
      $tbody=$(this).closest("tbody")

      var title_remove_num=parseInt($tbody.find(".title").text().match(/[0-9]+/));
      $("tbody").each(function( index ) {
        $title= $(this).find(".title");
        var str=$title.text();
        var title=str.match(/[0-9]+/);
        var title_num=parseInt(title);
        
        if (title_num> title_remove_num){
          var t=title_num-1;
          str=str.replace(title_num.toString(),t.toString());
          $title.text(str);
        } 
      });
      return false;
  });
});