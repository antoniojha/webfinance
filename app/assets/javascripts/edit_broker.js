/*
$(function(){
  $(document).delegate("#profile_info_edit","click",function(){
    $.get(this.href, null, null, "script");

    return false;
  });
  $(document).delegate(".edit_broker","submit",function(){
    var formData=$(this).serialize();
    $.post(null, formData, null, "script");
    return false;
  });
  $(document).delegate(".new_financial_product","submit",function(){
    var formData=$(this).serialize();
    $.post("/financial_products", formData, null, "script");
    return false;
  }); 
  
  $(document).delegate("#about_edit","click",function(){
    $.get(this.href, null, null, "script");
    return false;
  });  
  $(document).delegate(".financial_product_add_link","click",function(){
    $.get(this.href, null, null, "script");
    return false;
  }); 
  $(document).delegate("#skills_edit","click",function(){
    $.get(this.href, null, null, "script");
    return false;
  });    
});

*/