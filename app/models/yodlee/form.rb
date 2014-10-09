module Yodlee
  class Form
    attr_reader :fields, :wrapper
    
    def initialize opts
      @fields=opts[:fields]
      @wrapper=opts[:wrapper]
    end
    def render
      @fields.componentList.map do |element|
        type=element.fieldType.typeName.downcase.classify
        Yodlee::Fields.const_get(type).new(field: element, wrapper: wrapper).render
      end.join('').squish
    end
  end
end
