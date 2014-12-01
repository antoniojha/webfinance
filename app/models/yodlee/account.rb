
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

    def create creds 
      if cobrand_token && token && (bank.content_service_id) && (!creds.fetch("LOGIN").empty?) && (!creds.fetch("PASSWORD").empty?)
        
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
      else
        nil
      end
    end
    
    def get_accounts()
      if cobrand_token && token && item_id
        query({
          :endpoint=>'/jsonsdk/DataService/getItemSummaryForItem1',
          :method=> :POST,
          :params => {
            :cobSessionToken => cobrand_token,
            :userSessionToken => token,
            :itemId => item_id,
            :'dex.startLevel'=>0,
            :'dex.endLevel' =>0,
            :'dex.extentLevels[0]' => 4,
            :'dex.extentLevels[1]' => 4
            }   
          })
      else
        nil
      end
    end
    
    def get_all_transactions(item_account_id)
      end_number=100
      start_number=1  
      h=1
      begin    
        higher_limit=500*h
        lower_limit=500*(h-1)+1
        response=transaction_data(item_account_id,higher_limit,lower_limit, end_number,start_number)
        total_data=response.searchResult
        i=1 
        higher=100
        while (higher< response.numberOfHits) do  
          lower=(i-1)*100+1
          higher=i*100
          identifier=response.searchIdentifier
          data=transaction_data_view(identifier, lower,higher)
          total_data=total_data.merge(data)
          i=i+1
        end 
        h=h+1
      end while (higher_limit < response.countOfAllTransaction)

      total_data
    end
                 
      def self.save_to_spendings(response, account_item)
      response.transactions.each do |h|
        h1=h.postDate
        h2=h.transactionType
        h3=h.description.description
        cat_id=h.category.categoryTypeId
        if (cat_id==2)||(cat_id==5)
          h4=h.amount.amount
        elsif (cat_id==3)||(cat_id==4)
          h4=h.amount.amount*(-1)
        end
        hash={transaction_date:h1, category:h2,description:h3,amount:h4}
        account_item.create_spending(hash)
      end
    end  
    private
      
    def parse_creds creds
      if creds
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
      else
        nil
      end
    end
    def refresh
      if cobrand_token && token && item_id
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
      else
        nil
      end
    end
    def is_refreshing?
      if cobrand_token && token && item_id
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
      else
        nil
      end
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
      if cobrand_token && token && item_id
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
        else
          nil
        end
      else
        nil
      end
      
    end
      #traversing through transaction and store each chunk (500 maximum) in cache plus parse the first 100 transaction
      def transaction_data(item_account_id=nil,higher_limit=500,lower_limit=1, end_number=100, start_number=1)
        if cobrand_token && token
          query({
            :endpoint => '/jsonsdk/TransactionSearchService/executeUserSearchRequest',
            :method => :POST,
            :params => {
              :cobSessionToken => cobrand_token,
              :userSessionToken => token,
              :'transactionSearchRequest.containerType'=>'All',
              :'transactionSearchRequest.higherFetchLimit'=>higher_limit,
              :'transactionSearchRequest.lowerFetchLimit'=>lower_limit,
              :'transactionSearchRequest.resultRange.endNumber'=>end_number,
              :'transactionSearchRequest.resultRange.startNumber'=>start_number,
              :'transactionSearchRequest.searchClients.clientId'=>1,
              :'transactionSearchRequest.searchClients.clientName'=>'DataSearchService',
              :'transactionSearchRequest.userInput'=>nil,
              :'transactionSearchRequest.ignoreUserInput'=>true,
              :'transactionSearchRequest.searchFilter.currencyCode'=>'USD',
              :'transactionSearchRequest.searchFilter.postDateRange.fromDate'=>1.year.ago.strftime('%m-%d-%YT00:00:00.000Z'),
              :'transactionSearchRequest.searchFilter.postDateRange.toDate'=>Time.zone.now.strftime('%m-%d-%YT00:00:00.000Z'),
              :'transactionSearchRequest.searchFilter.transactionSplitType'=> 'ALL_TRANSACTION',
              :'transactionSearchRequest.searchFilter.itemAccountId.identifier' => item_account_id
              }    
            })
        else
          nil
        end
    end
      # Traverse through each 100 transaction until finishing parsing transactions in cache (500 maximum)
    def transaction_data_view(searchIdentifier, start_number=1,end_number=100)
      if searchIdentifier
        query({
          :endpoint => '/jsonsdk/TransactionSearchService/getUserTransactions',
          :method => :POST,
          :params => {
            :cobSessionToken => cobrand_token,
            :userSessionToken => token,
            :'searchFetchRequest.searchIdentifier.identifier' => searchIdentifier,
            :'searchFetchRequest.searchResultRange.startNumber' => start_number,
            :'searchFetchRequest.searchResultRange.endNumber' => end_number
          }  
        })
      else
        nil
      end
    end 
  end
end
