module Yodlee
  class Bank <Base
    def initialize bank
      @bank=bank
    end
    
    def content_service_id
      @bank.content_service_id
    end
    
    def login_requirements
      query({
        :endpoint=>'/jsonsdk/ItemManagement/getLoginFormForContentService',
        :method=>:POST,
        :params=>{
          :cobSessionToken=> cobrand_token,
          :contentServiceId=>content_service_id
        }
      })
    end
    def form opts={}
      @form ||=Yodlee::Form.new(opts.merge({fields: login_requirements})).render
    end
  end
end