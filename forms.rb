
class Field
  attr_accessor :type, :label_text, :name, :help_text, :html_id

  def initialize(type, label_text=nil, attributes=nil, help_text=nil )
    @type, @label_text, @help_text, @attributes = type, label_text, help_text, attributes
    unless attributes.nil?
      raise "Field.html_id is defined by the class value the field is set to" if attributes.has_key?(:id)
      raise "Field.name is defined by the class value the field is set to" if attributes.has_key?(:name)
    end
  end

  def to_html
    value_pairs = @attributes.to_a.map {|key,value| "#{key}='#{value}'"}
    value_pairs << "name='#{self.name}'"
    value_pairs << "id='#{self.html_id}'"
    value_pairs = value_pairs.join ' '
    return "<input type='#{self.type}' #{value_pairs} />"
  end

  def label
    "<label for='#{self.html_id}'>#{self.label_text}</label>"
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
      field.html_id = "id_#{field_name}".to_sym
      @fields << field
    end
  end

end
