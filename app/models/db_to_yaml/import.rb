require 'yaml'

module DbToYaml
  class Import

    def load_banks
    File.open("#{Rails.root}/config/Bank.yml",'r'){|multifile|
      YAML.load_documents(multifile){|doc|
        h1=doc['id']
        h2=doc['content_service_id']
        h3=doc['content_service_display_name']
        h4=doc['site_id']
        h5=doc['site_display_name']
        h6=doc['mfa']
        h7=doc['home_url']
        h8=doc['bank']
        hash={:id=>h1,:content_service_id=>h2,:content_service_display_name=>h3,:site_id=>h4,:site_display_name=>h5,:mfa=>h6,:home_url=>h7,:container=>h8}
       
        row=Bank.where(id:h1).first_or_create
        row.update_attributes!(hash)
        }
      } 
    end
  end
end