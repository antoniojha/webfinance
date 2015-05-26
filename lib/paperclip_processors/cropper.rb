module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
     #   puts "this is super #{super}"
        #  for some reason cropper is using medium size as default, therefore there is a "200px" in super. substitute this with the width size of original picture, which is a lot bigger. This increases picture quality for cropping.
        puts "this is super #{super}"
        super.join(' ').sub(/ -crop \S+/, crop_command).sub(/"200x"/,"#{@attachment.instance.picture_geometry(:original).width}x").sub(/"x200"/,"#{@attachment.instance.picture_geometry(:original).width}x").split(' ') 
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        " -crop #{target.crop_w}x#{target.crop_h}+#{target.crop_x}+#{target.crop_y}"
      end
    end
  end
end