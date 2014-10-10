module Yodlee
  class Misc
    def self.password_generator
      chars='abcdefghijklmnopqrstuvwxyz1234567890'
      password=chars.last(10).split(//).sample
      begin
        char=chars[rand(chars.size)]
        password<<char if password[-1] != char
      end while password.length <32
      password
    end
  end
end
  