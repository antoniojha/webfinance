# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  
  include CarrierWaveDirect::Uploader

  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
   include CarrierWave::MiniMagick
  #This will set the MIME type for the image in case it’s incorrect.
   include CarrierWave::MimeTypes
   
   process :set_content_type
  # Choose what kind of storage to use for this uploader:
  if Rails.env.test?   
    storage :file 
  end
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def auto_orient
    puts "auto_orient"
    manipulate! do |img|
      img.auto_orient
      img
    end
  end  
  version :thumb_200 do
    process :crop
    resize_to_fill(200, 200)
  end
  version :thumb_400 do
    process :resize_to_limit => [400, 0]
  end

  def crop
    if model.crop_x.present?
      resize_to_limit(400, 0)   
      url=model.remote_image_url
      x = model.crop_x.to_i
      y = model.crop_y.to_i
      w = model.crop_w.to_i
      h = model.crop_h.to_i
      crop_params="#{w}x#{h}+#{x}+#{y}"
      puts "#{crop_params}"
      manipulate! do |img|
        img = MiniMagick::Image.open(url)
        img.crop(crop_params)
        img = yield(img) if block_given?
        img
      end
    end
  end
  def get_geometry
    puts "#{@file.url}"
    if (@file.url)
      img = MiniMagick::Image::open(@file.url)
      @geometry = [ img.width.to_i, img.height.to_i ]
    end
  end
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
