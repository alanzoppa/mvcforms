require './fields'

class Form
  attr_accessor :fields

  def _attach_field_name(field, field_name)
      field.name = field_name.to_sym
      @fields << field
  end

  def initialize 
    @fields = Array.new

    self.class.class_variables.each do |v| # All class variables which are instances of Field
      field = self.class.class_variable_get(v)
      field_name = v.to_s.gsub(/^@@/, '')

      if field.class == Array && field.all? {|f| f.class.superclass == Field}
        raise "Fields must be of the same type" unless field.all? {|f| f.class == field[0].class }
        field.each {|f| _attach_field_name(f, field_name) }
      elsif field.class.superclass == Field
        _attach_field_name(field, field_name)
      end
    end

  end

end
