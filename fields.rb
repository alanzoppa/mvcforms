require './test_module' if $test_env

def symbolize string
  string.to_s.gsub(/ /, '_').downcase.to_sym
end

def flatten_attributes(hash=nil)
  hash.to_a.map {|key,value| "#{key}='#{value}'"}.join ' '
end

def wrap_tag(string, with=:p, attributes=nil)
  with_open = 
    attributes.nil? ? with : "#{with} " + flatten_attributes(attributes)
  return "<#{with_open}>#{string}</#{with}>"
end

class Field
  include TestModule if $test_env
  attr_accessor :type, :label_text, :name, :help_text, :html_id, :errors

  def initialize(label_text=nil, attributes=nil, help_text=nil )
    @label_text, @attributes, @help_text = label_text, attributes, help_text
    @type = self.class.to_s.gsub(/Field$/, '').downcase
  end

  def html_id
    "id_#{@name}".to_sym
  end

  def to_html
    value_pairs = @attributes.nil? ? Hash.new : @attributes.dup
    value_pairs[:type] = @type
    value_pairs[:name] = self.name
    value_pairs[:id] = self.html_id
    return "<input #{flatten_attributes value_pairs} />"
  end

  def label_tag
    "<label for='#{self.html_id}'>#{self.label_text}</label>"
  end

  def to_labeled_html
    label_tag + to_html
  end

end

class TextField < Field
end

class CheckboxField < Field
  def to_labeled_html
    to_html + label_tag
  end
end

class ChoiceField < Field
  def initialize(label_text, values, attributes = Hash.new)
    @label_text, @values, @attributes = label_text, values, attributes
  end

  def _html_options
    @values.map { |v| "\n  " + "<option value='#{symbolize v}'>#{v}</option>" }.join
  end

  def to_html
    "\n" + wrap_tag("#{_html_options}\n", :select, {:id => html_id, :name => @name})
  end
end

class RadioField < Field
  def initialize(value, attributes = Hash.new)
    @value, @attributes, @type = value, attributes, :radio
    @attributes[:value] = @value.downcase
    @label_text = @value
    @type = :radio
  end

  def html_id
    "id_#{@name}_#{@value}".downcase
  end

  def to_labeled_html
    "  " + to_html + label_tag + "\n"
  end
end

class RadioChoiceField < Field
  attr_accessor :fields

  def initialize(label_text, values, attributes = Array.new)
    @label_text, @values, @attributes = label_text, values, attributes
    @fields = values.map { |value| RadioField.new(value) }
  end

  def html_id
    "id_#{@name}"
  end

  def attach_names! name
    @fields.each {|field| field.name = name }
  end

  def _html_options
    @fields.map { |v| v.to_labeled_html }.join
  end

  def fieldset_legend
    "\n  <legend>#{self.label_text}</legend>\n"
  end

  def to_html
    wrap_tag(fieldset_legend + self._html_options, :fieldset, {:id => html_id})
  end
end
