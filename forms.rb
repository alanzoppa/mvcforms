require './test_module' if $test_env
require "./fields"

class Form
  include TestModule if $test_env
  attr_accessor :fields

  def initialize 
    _define_defaults
    _initialize_fields
    _prepare_getters
  end

  def redefine_defaults
  end

  def _define_defaults
    @__settings = {:wrapper => :p, :wrapper_attributes => nil, :pretty_print => true}
    redefine_defaults
    @pretty_print = @__settings[:pretty_print]
  end

  def _initialize_fields
    @fields = Array.new
    self.class.class_variables.each { |v|
      __flatten_fields field=self.class.class_variable_get(v), field_name=v.to_s.gsub(/^@@/, '')
    }
  end

  def __flatten_fields(field, field_name)
    if field.class == Array && field.all? {|f| f.class.superclass == Field}
      raise "Fields must be of the same type" unless field.all? {|f| f.class == field[0].class }
      field.each {|f| ___attach_field_attributes(f, field_name) }
    elsif field.class.superclass == Field
      ___attach_field_attributes(field, field_name)
    end
  end

  def ___attach_field_attributes(field, field_name)
    field.name = field_name.to_sym
    field.attach_names!(field_name) if field.respond_to?(:attach_names!)
    field.pretty_print = @pretty_print
    @fields << field
  end

  def _prepare_getters
    @queryable_structures = Hash.new
    @fields.each do |field|
      @queryable_structures[field.name.to_sym] = {
        :field => field.to_html,
        :label_tag => field.label_tag,
        :help_text => field.help_text,
        :errors => field.errors,
        :instance => field
      }
    end
  end
  
  def get_group field
    return @queryable_structures[field.to_sym]
  end

  def get(type, field)
    return get_group(field.to_sym)[type.to_sym]
  end

  def get_field field
    return get_group(field)[:field]
  end

  def get_label_tag field
    return get_group(field)[:label_tag]
  end

  def get_help_text field
    return get_group(field)[:help_text]
  end

  def get_errors field
    return get_group(field)[:errors]
  end
 
  def to_html(tag=@__settings[:wrapper], attributes=@__settings[:wrapper_attributes])
    output = String.new
    @fields.each do |field|
      if @__settings[:pretty_print]
        field_contents = field.to_labeled_html.indent.template("\n%s\n")
        output += wrap_tag(field_contents, tag, attributes)
        output += "\n" unless field == @fields.last and @fields.length > 1
      else
        output += wrap_tag(field.to_labeled_html, tag, attributes)
      end
    end
    return output
  end
  
end
