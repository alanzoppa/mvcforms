require "./fields"

class Form
  attr_accessor :fields

  def initialize 
    _initialize_fields
    _prepare_getters
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
      field.each {|f| ___attach_field_name(f, field_name) }
    elsif field.class.superclass == Field
      ___attach_field_name(field, field_name)
    end
  end

  def ___attach_field_name(field, field_name)
    field.name = field_name.to_sym
    field.attach_names!(field_name) if field.respond_to?(:attach_names!)
    @fields << field
  end

  def _prepare_getters
    @queryable_structures = Hash.new
    @fields.each do |field|
      @queryable_structures[field.name.to_sym] = {
        :field => field.to_html,
        :label_tag => field.label_tag,
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
  
end
