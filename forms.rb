class Field
  attr_accessor :type, :name, :css_class

  def initialize(type, name, cl=nil)
    self.type, self.name, self.css_class = type, name, cl
  end

  def render
    case self.type
      when :input
        return "<input type='text' name='#{self.name}' />"
      else
        return "bar"
    end
    return true
  end

end


class Form
  def fields
    @base_class = self.class
    @class_vars = @base_class.class_variables.map { |v| @base_class.class_variable_get(v) }
    #@class_vars.map! { |v| @base_class.class_variable_get(v) }
    #puts @class_vars
    #return "foo"
    #self.class.class_variables.map {|v| self.class.class_variable_get(v)}
  end
end
