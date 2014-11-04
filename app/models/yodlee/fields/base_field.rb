module Yodlee
  module Fields
    class BaseField
      attr_reader :field
      
      def initialize opts
        @field=opts[:field]
        @wrapper=opts[:wrapper]
      end

      def render opts
        percent = opts.fetch(:percent, 50)
       # percent=opts[:percent]
        
        "<table width=#{percent}%><tr width=100%><td width=50%>
        <label>#{label} #{asterisk}</label></td>
<td width=50%>#{input}</td>
        </tr></table>" if required?
      end
      def label
        field.displayName
      end
      def asterisk
        field.isOptional ? '' : '*'
      end
      def requirement
        field.isOptional ? 'optional' : 'required'
      end
      def required?
        !field.isOptional
      end
      def size
        field['size']
      end
      def maxlength
        field.maxlength
      end
      def value
        field.value
      end
      def name
        name=field.valueIdentifier

        if @wrapper.present?
          @wrapper + '['+name+']'
        else
          name
        end
      end
    end
  end
end