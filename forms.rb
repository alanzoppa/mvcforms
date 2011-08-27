require "./fields"

class Form
  attr_accessor :fields

  def initialize 
    _initialize_fields
  end

  def _initialize_fields
    @fields = Array.new
    self.class.class_variables.each { |v|
      _flatten_fields field=self.class.class_variable_get(v), field_name=v.to_s.gsub(/^@@/, '')
    }
  end

  def _flatten_fields(field, field_name)
    if field.class == Array && field.all? {|f| f.class.superclass == Field}
      raise "Fields must be of the same type" unless field.all? {|f| f.class == field[0].class }
      field.each {|f| _attach_field_name(f, field_name) }
    elsif field.class.superclass == Field
      _attach_field_name(field, field_name)
    end
  end

  def _attach_field_name(field, field_name)
    field.name = field_name.to_sym
    field.attach_names!(field_name) if field.respond_to?(:attach_names!)
    @fields << field
  end
  
end
