module Yodlee
  class Account < Base
    attr_reader :account
    def initialize account
      @account=account
    end
    def bank
      @bank ||= account.bank
    end
    def user
      @user ||= account.user
    end
    def item_id
      account.yodlee_id
    end
    def token
      user.yodlee.token
    end
    def parse_creds creds
      all_fields=bank.yodlee.login_requirements.componentList
      creds.each_with_index.inject({}) do |sum,(cred,index)|
        key, value=cred
        field=all_fields.find{|f| f.valueIdentifier==key}
        sum[:"credentialFields[#{index}].fieldType.typeName"]=field.fieldType.typeName
        sum[:"credentialFields[#{index}].value"]=value
        %w(displayName helpText maxlength name size valueIdentifier valueMask isEditable isOptional isEscaped isMFA isOptionalMFA).each do |attr|
          sum[:"credentialFields[#{index}].#{attr}"]=field.send(attr)
        end
        sum      
      end  
    end
    def create creds 
      response=query({
        :endpoint=>'/jsonsdk/ItemManagement/addItemForContentService1',
        :method => :POST,
        :params => {
          :cobSessionToken => cobrand_token,
          :userSessionToken => token,
          :contentServiceId => bank.content_service_id,
          :shareCredentialsWithinSite => true,
          :startRefreshItemOnAddition => false,
          :'credentialFields.enclosedType'=> 'com.yodlee.common.FieldInfoSingle'     
          }.merge(parse_creds(creds))
      })
      if response
        account.update_attributes!(yodlee_id: response.primitiveObj)
        refresh
        ping
      end
    end
    def refresh
      query({
        :endpoint =>'/jsonsdk/Refresh/startRefresh7',
        :method => :POST,
        :params => {
          :cobSessionToken => cobrand_token,
          :userSessionToken => token,
          :itemId => item_id,
          :'refreshParameters.refreshMode.refreshMode'=>'NORMAL',
          :'refreshParameters.refreshMode.refreshModeId'=> 2,
          :'refreshParameters.refreshPriority'=>1
          }
        })
    end
    def is_refreshing?
      response=query({
        :endpoint=>'/jsonsdk/Refresh/isItemRefreshing',
        :method=> :POST,
        :params=>{
          :cobSessionToken => cobrand_token,
          :userSessionToken => token,
          :memItemId => item_id
          }
        
        })
      response.primitiveObj
    end
    def ping
      sleep(2)
      if is_refreshing?
        ping
      else
        get_last_refresh_info
      end
    end
    def get_last_refresh_info
      response=query({
        :endpoint => '/jsonsdk/Refresh/getRefreshInfo1',
        :method => :POST,
        :params => {
          :cobSessionToken => cobrand_token,
          :userSessionToken => token,
          :'itemIds[0]'=> item_id      
          }
        })
      if response && response = response.find{|a| a.itemId==item_id}
        account.status_code=response.statusCode
        account.last_refresh=Time.at(response.lastUpdateAttemptTime)
        account.save
      end     
    end
    def transaction_data
      query({
        :endpoint => '/jsonsdk/TransactionSearchService/executeUserSearchRequest',
        :method => :POST,
        :params => {
          :cobSessionToken => cobrand_token,
          :userSessionToken => token,
          :'transactionSearchRequest.containerType'=>'BANK',
          :'transactionSearchRequest.higherFetchLimit'=>500,
          :'transactionSearchRequest.lowerFetchLimit'=>1,
          :'transactionSearchRequest.resultRange.endNumber'=>100,
          :'transactionSearchRequest.resultRange.startNumber'=>1,
          :'transactionSearchRequest.searchClients.clientId'=>1,
          :'transactionSearchRequest.searchClients.clientName'=>'DataSearchService',
          :'transactionSearchRequest.userInput'=>nil,
          :'transactionSearchRequest.ignoreUserInput'=>true,
          :'transactionSearchRequest.searchFilter.currencyCode'=>'USD',
          :'transactionSearchRequest.searchFilter.postDateRange.fromDate'=>1.year.ago.strftime('%m-%d-%Y'),
          :'transactionSearchRequest.searchFilter.postDateRange.toDate'=>Time.zone.now.strftime('%m-%d-%Y'),
          :'transactionSearchRequest.searchFilter.transactionSplitType'=> 'ALL_TRANSACTION'
          }    
        })
    end
    def transaction_data_view(searchIdentifier)
      query({
        :endpoint => '/jsonsdk/TransactionSearchService/getUserTransactions',
        :method => :POST,
        :params => {
          :cobSessionToken => cobrand_token,
          :userSessionToken => token,
          :'searchFetchRequest.searchIdentifier.identifier' => searchIdentifier,
          :'searchFetchRequest.searchResultRange.startNumber' => 1,
          :'searchFetchRequest.searchResultRange.endNumber' => 100
        }  
      })
    end
    
  end
end
