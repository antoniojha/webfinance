module Yodlee
  class Importer <Base
    def content_services *type
      # types allowed: :all, OR specific type(s), :bank, :credits, :miles, :loans etc
      all_content_services.each do |bank|
        container =bank.containerInfo.containerName.to_sym
        next unless Array(type).include?(container) || type == :all
        
        mfa=bank.key?('mfaType') ? bank.mfaType.typeName : 'none'
        
        row= ::Bank.where(content_service_id: bank.contentServiceId).first_or_create
        row.update_attributes!(
          :content_service_id=> bank.contentServiceId,
          :home_url=> bank.homeUrl,
          :content_service_display_name=> bank.contentServiceDisplayName,
          :site_id=> bank.siteId,
          :site_display_name=> bank.siteDisplayName,
          :container=> container,
          :mfa=> mfa
        )
      end
    end
    def content_service
      ::Bank.all.each do |bank|
        id=bank.content_service_id
        response=single_content_service(id)
        bank.update_attributes!(
          :content_service_display_name=> response.contentServiceDisplayName,
          :site_display_name=>response.siteDisplayName,
          :home_url=> response.homeUrl
        )
      end
    end
    def import_one_content_service(id)
          response=single_content_service(id)
          bank=::Bank.find_by_content_service_id(id)
          bank.update_attributes!(
          :content_service_display_name=> response.contentServiceDisplayName,
          :site_display_name=>response.siteDisplayName,
          :home_url=> response.homeUrl
        )
    end
    private
    
    def all_content_services
      query({
        :endpoint => '/jsonsdk/ContentServiceTraversal/getAllContentServices',
        :method => :POST,
        :params => {
          :cobSessionToken=> cobrand_token,
          :notrim=> false
        }
      })
    end   
    def single_content_service (contentServiceId)
      query({
        :endpoint => '/jsonsdk/ContentServiceTraversal/getContentServiceInfo1',
        :method => :POST,
        :params => {
          :cobSessionToken=> cobrand_token,
          :contentServiceId=>contentServiceId,
          :reqSpecifier=>1,
          :notrim=> true
        }
      })      
    end
     
  end
end