module Yodlee
  module Fields
    class IfLogin < BaseField
      def input
        "<input class='string #{requirement}' id='#{name}' name='#{name}' size='#{size}'
        type='text' maxlength='#{maxlength}' value='#{value}'/>"
      end   
    end
  end
end