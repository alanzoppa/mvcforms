module ChoiceHelper
  def initialize(label_text, value, attributes = Hash.new)
    @label_text, @value, @attributes = label_text, value, attributes
    @attributes[:value] = value
    _post_initialize
  end

  def html_id
    "id_#{@name}_#{@value}"
  end
end


