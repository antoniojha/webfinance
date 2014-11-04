require 'yaml/store'
module DbToYaml
  class Export
     yaml_path="#{Rails.root}/config/"
    def export_from_db (*args)
      args.each do |m|
  
        yaml_path="#{Rails.root}/config/#{m}.yml"
        puts yaml_path
        File.open(yaml_path,  "w") do |f|
          m.all.each do |r|
            f.write(r.to_yaml)
          end          
        end
      end
    end
    def initialize
    end
  end
end