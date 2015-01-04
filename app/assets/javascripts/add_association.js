$(function(){
  $('.add_association').click(function(){
    $.get(this.href, null, null, 'script');
    return false;
  });
  return false;
});