module Yodlee
  class User <Base
    attr_reader :user
    def initialize user
      @user=user
    end
    def register 
      response=query({
        :endpoint=>'/jsonsdk/UserRegistration/register3',
        :method=> :POST,
        :params=> {
          :cobSessionToken=>cobrand_token,
          :'userCredentials.loginName'=> user.yodlee_username,
          :'userCredentials.password'=> user.yodlee_password,
          :'userCredentials.objectInstanceType'=>'com.yodlee.ext.login.PasswordCredentials',
          :'userProfile.emailAddress'=> user.yodlee_username      
          }     
        })
      @token=response.userContext.conversationCredentials.sessionToken
    end
    def login
      response=query({
        :endpoint=>'/authenticate/login',
        :method=> :POST,
        :params=> {
          :cobSessionToken =>cobrand_token,
          :login => user.yodlee.user_name,
          :password => user.yodlee.password
          }
        
        })
      @token=response.userContext.conversationCredentials.sessionToken
    end
    def token
      @token ||= login
    end
    def destroy
      response=query({
        :endpoint=>'/jsonsdk/UserRegistration/unregister',
        :method=> :POST,
        :params=>{
          :cobSessionToken=> cobrand_token,
          :userSessionToken=> token
          }   
        })
      @token=nil
    end
    
  end
end
