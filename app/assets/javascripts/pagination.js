$(function(){
  $(document).delegate(".pagination li a","click",function(){
    $(".pagination").html('Page is loading...')
    $.get(this.href, null, null, 'script');
    return false;
  });
});