module Yodlee
  class Base
    include HTTParty
    def login_app
      credentials={
        :cobrandLogin => Yodlee::Config.username,
        :cobrandPassword => Yodlee::Config.password  
      }
      response=self.class.post('/authenticate/coblogin', query: credentials)
    end
  end
end