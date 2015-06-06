
jQuery.fn.submitWithAjax=function(){
  // based on code provided in http://railscasts.com/episodes/136-jquery?view=asciicast and http://stackoverflow.com/questions/6723334/submit-form-in-rails-3-in-an-ajax-way-with-jquery
  this.submit(function(){
    var values=$(this).serialize();       
    $.ajax({
      type:"POST",
      url: $(this).attr('action'),
      data: values,
      dataType: "JSON"
    }).success(function(json){
      alert(JSON.stringify(json));
      console.log("success", json);
    });
    return false;
  });
}
$("#add_education").submitWithAjax();
