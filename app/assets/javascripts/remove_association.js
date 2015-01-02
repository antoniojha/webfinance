$(function(){
  $(document).delegate(".remove_association","click", function(){
      $(this).closest("tbody").hide();
      $(this).closest("td").prev().find("input").attr("value","true");
      $.get(this.href, null, null, 'script');
      var id=$(this).closest("tbody").attr("id");
      var id_match=id.match(/[0-9]+/);
      var id_base=id.replace(id_match,"");

      $("tbody[id^='"+id_base+"']").each(function( index ) {
        var str=$(this).find(".title").text();
        var i_match=str.match(/[0-9]+/);
        var id_i=parseInt(id_match)+1;
        if (parseInt(i_match) > (id_i)){
          var i_title=parseInt(i_match)-1;
          str=str.replace(i_match,i_title.toString())
          $(this).find(".title").text(str);
          console.log( "title:"+str+" : "+i_match );
          
        }
 //       var i=index+1;
 //       str=str.replace(i_match,i);
 //       $(this).find(".title").text(str);
        
      });
      return false;
  });
});