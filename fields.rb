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
  def initialize(label_text, attributes = Hash.new)
    @label_text, @value, @attributes = label_text, symbolize(label_text), attributes
    @attributes[:value] = @value
    @type = :radio
  end

  def html_id
    "id_#{@name}_#{@value}"
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

class TextField < Field
end

class CheckboxField < Field
end
