
class Field
  attr_accessor :type, :label_text, :name, :help_text, :html_id

  def _standard_validation
    unless @attributes.nil?
      raise "Field.html_id is defined by the class value the field is set to" if @attributes.has_key?(:id)
      raise "Field.name is defined by the class value the field is set to" if @attributes.has_key?(:name)
    end
  end

  def initialize(label_text=nil, attributes=nil, help_text=nil )
    @label_text, @help_text, @attributes = label_text, help_text, attributes
    _standard_validation
    @type = self.class.to_s.gsub(/Field$/, '').downcase
  end

  def to_html
    value_pairs = @attributes.to_a.map {|key,value| "#{key}='#{value}'"}
    value_pairs << ["name='#{self.name}'", "id='#{self.html_id}'"]
    value_pairs = value_pairs.join ' '
    return "<input type='#{self.type}' #{value_pairs} />"
  end

  def label
    "<label for='#{self.html_id}'>#{self.label_text}</label>"
  end

end

class RadioField < Field
  def initialize(label_text, value, name)
    @label_text, @value, @name = label_text, value, name
    @type = :radio
    @html_id = "id_#{@name}_#{@value}"
  end

  def to_labeled_html
    "<input type='#{@type}' name='#{@name}' id='#{@html_id}' value='#{@value}'><label for='#{@html_id}'>#{@label_text}</label>"
  end
end

class RadioChoiceField < Field
  def initialize(value_array, attributes, help_text)
  end
end

class TextField < Field
end

class CheckboxField < Field
end

class Form
  attr_accessor :fields

  def _attach_field_name(field, field_name)
      field.name = field_name.to_sym
      field.html_id = "id_#{field_name}".to_sym
      @fields << field
  end

  def initialize 
    @fields = Array.new

    # All class variables which are instances of Field
    field_pairs = Array.new
    self.class.class_variables.each do |v|
      #if [TextField, CheckboxField, RadioChoiceField].include?(field.class)
      if field.class.superclass == Field
        _attach_field_name( field, v.to_s.gsub(/^@@/, '') )
      end
    end

  end

end
