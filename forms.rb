
class Field
  attr_accessor :type, :label, :name, :help_text, :html_id

  def initialize(type, attributes=nil, label=nil, help_text=nil)
    @type, @attributes = type, attributes
    unless attributes.nil?
      raise "Field.html_id is defined by the class value the field is set to" if attributes.has_key?(:id)
      raise "Field.name is defined by the class value the field is set to" if attributes.has_key?(:name)
    end
  end

  def to_html
    value_pairs = @attributes.to_a.map {|key,value| "#{key}='#{value}'"}
    value_pairs << "name='#{self.name}'"
    value_pairs << "id='id_#{self.name}'"
    value_pairs = value_pairs.join ' '
    return "<input type='#{self.type}' #{value_pairs} />"
  end

end


class Form
  attr_accessor :fields

  def initialize 
    @fields = Array.new

    # All class variables which are instances of Field
    field_pairs = self.class.class_variables.map { |v|
      if self.class.class_variable_get(v).class == Field
        [ self.class.class_variable_get(v), v.to_s.gsub(/^@@/, '') ]
      end
    }
    field_pairs.each do |field, field_name|
      field.name = field_name.to_sym
      @fields << field
    end
  end

end
