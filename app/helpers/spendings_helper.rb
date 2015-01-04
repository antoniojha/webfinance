module SpendingsHelper
  def sortable_link(column,title=nil,page_num=1)
    title||=column.titleize
    direction=(column==sort_column && sort_direction=='asc') ? "desc" : "asc"
    
    if column==sort_column
      if sort_direction=='asc'  
        image=image_tag("glyphicons-602-chevron-down.png",size:"10x10")
      elsif sort_direction=='desc'
        image=image_tag("glyphicons-601-chevron-up.png",size:"10x10")
      end
    end
    link_to (title+"#{image}").html_safe,{page:page_num,sort:column,direction:direction}
  end
end
