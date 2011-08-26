require './test_module' if $test_env

def symbolize string
  string.to_s.gsub(/ /, '_').downcase.to_sym
end

class Field
  include TestModule if $test_env
  attr_accessor :type, :label_text, :name, :help_text, :html_id

  def initialize(label_text=nil, attributes=nil, help_text=nil )
    @label_text, @help_text, @attributes = label_text, help_text, attributes
    @type = self.class.to_s.gsub(/Field$/, '').downcase
  end

  def html_id
    self.html_id = "id_#{@name}".to_sym
  end

  def to_html
    value_pairs = @attributes.to_a.map {|key,value| "#{key}='#{value}'"}
    value_pairs << ["name='#{self.name}'", "id='#{self.html_id}'"]
    value_pairs = value_pairs.join ' '
    return "<input type='#{self.type}' #{value_pairs} />"
  end

  def label_tag
    "<label for='#{self.html_id}'>#{self.label_text}</label>"
  end

  def to_labled_html
    label_tag + to_html
  end

end

class RadioField < Field
  def initialize(value, attributes = Hash.new)
    @value, @attributes, @type = value, attributes, :radio
    @attributes[:value] = @value.downcase
    @label_text = @value
  end

  def _html_options
    @value.map { |v| "<input type='radio' value='#{v}' name='#{@name}' id='#{html_id}' />" }.join
  end

  def html_id
    "id_#{@name}_#{@value}".downcase
  end

  def to_labeled_html
    to_html + label_tag
  end
end

class ChoiceField < Field
  def initialize(label_text, values, attributes = Hash.new)
    @label_text, @values, @attributes = label_text, values, attributes
  end

  def html_id
    "id_#{@name}"
  end

  def _html_options
    @values.map { |v| "<option value='#{symbolize v}'>#{v}</option>" }.join
  end

  def to_html
    "<select name='#{@name}' id='#{html_id}'>#{_html_options}</select>"
  end
end

class RadioChoiceField < Field
  def initialize(values, attributes = Array.new)
    @values, @attributes, @value = values, attributes, :radio
    @fields = values.map { |value| RadioField.new(value) }
  end

  def _html_options
    @values.map { |v| "<option value='#{symbolize v}'>#{v}</option>" }.join
    #<input type='radio' name='#{@name}' value='#{symbolize v}'><br>
  end
end

class TextField < Field
end

class CheckboxField < Field
end
