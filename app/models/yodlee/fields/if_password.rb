module Yodlee
  module Fields
    class IfPassword < BaseField
      def input
        "<input class='string #{requirement}' id='#{name}' name='#{name}' size='#{size}'
        type='password' maxlength='#{maxlength}' value='#{value}'/>"
      end   
    end
  end
end

    