$(function(){
  $(document).delegate(".remove_association","click", function(){
      $(this).closest("tbody").hide();
      $(this).closest("td").prev().find("input").attr("value","true");
      $.get(this.href, null, null, 'script'); // ajax call
      $tbody=$(this).closest("tbody")
      var id=$tbody.attr("id"); // get id for the association
      var id_num=id.match(/[0-9]+/); // get 
      var id_base=id.replace(id_num,"");
      var title_remove=parseInt($tbody.find(".title").text().match(/[0-9]+/));
      $("tbody[id^='"+id_base+"']").each(function( index ) {
        $title= $(this).find(".title");
        var str=$title.text();
        var title_num=str.match(/[0-9]+/);
        var title=parseInt(title_num);
        
        if (title> title_remove){
          var t=title-1;
          str=str.replace(title.toString(),t.toString());
          $title.text(str);
        } 
      });
      return false;
  });
});