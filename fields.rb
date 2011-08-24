require './test_module' if $test_env

def symbolize string
  string.gsub(/ /, '_').to_sym
end

class Field
  include TestModule if $test_env
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
  def initialize(label_text, value, attributes = Hash.new)
    @label_text, @value, @attributes = label_text, value, attributes
    @attributes[:value] = value
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
  def initialize(label_text, value, attributes = Hash.new)
    @label_text, @value, @attributes = label_text, value, attributes
    @attributes[:value] = value
    @type = :radio
  end

  def html_id
    "id_#{@name}_#{@value}"
  end

end

class TextField < Field
end

class CheckboxField < Field
end
