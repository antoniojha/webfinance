module OmniauthMacros
  def mock_auth_hash_twitter
    OmniAuth.config.mock_auth[:twitter] =  OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '123545',
      'info' => {
        'nickname'=> 'antoniojha',
        'name'=> 'antonio jha'
      }
    })
  end
  def mock_auth_hash_linkedin
    OmniAuth.config.mock_auth[:linkedin] =  OmniAuth::AuthHash.new({
      'provider' => 'linkedin',
      'uid' => '123545',
      'info' => {
        'nickname'=> 'antoniojha',
        'name'=> 'antonio jha',
        'email'=>'antoniojha@gmail.com'
      }
    })
  end
  def mock_auth_hash_facebook
    OmniAuth.config.mock_auth[:facebook] =  OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'first_name'=> 'antonio',
        'last_name'=> 'jha',
        'email'=>'antoniojha@gmail.com'
      }
    })
  end  
  def mock_auth_hash_googleplus
    OmniAuth.config.mock_auth[:google_oauth2] =  OmniAuth::AuthHash.new({
      'provider' => 'google_oauth2',
      'uid' => '123545',
      'info' => {
        'first_name'=> 'antonio',
        'last_name'=> 'jha',
        'email'=>'antoniojha@gmail.com'
      }
    })
  end  
end