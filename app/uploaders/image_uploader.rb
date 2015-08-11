# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  
  include CarrierWaveDirect::Uploader
  #This will set the MIME type for the image in case it’s incorrect.

  
  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
   include CarrierWave::MiniMagick
  #  include CarrierWave::MimeTypes
  #  process :set_content_type
  # Choose what kind of storage to use for this uploader:
 #  storage :file
  
 #  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
   def store_dir    
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
   end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  # include CarrierWave::MimeTypes
  # process :set_content_type
  # Create different versions of your uploaded files:
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
      
      manipulate! do |img|
        img = MiniMagick::Image.open(url)
        img.crop(crop_params)
        img = yield(img) if block_given?
        img
      end
    end
  end
  def get_geometry
    if (@file.url)
      img = MiniMagick::Image::open(@file.url)
      @geometry = [ img['width'], img['height'] ]

    end
  end
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
