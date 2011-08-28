$test_env = true
require './forms'

require "./fields_spec"
require "./helpers_spec"

describe "A Form with a TextField" do
  before do
    class TextFieldForm < Form
      @@text_field = TextField.new("Herp some derps")
    end
    @text_form = TextFieldForm.new
    @text_field = @text_form.fields[0]

    class DefaultAttributesForm < Form
      def _define_defaults
        super
        @__settings[:wrapper] = :span
        @__settings[:wrapper_attributes] = {:class => :some_herps}
      end

  #def _define_defaults
    #@__settings = {:wrapper => :p, :wrapper_attributes => nil}
  #end



      @@text_field = TextField.new("Herp some derps")
    end

    @default_attributes_form = DefaultAttributesForm.new
    @default_attributes_field = @default_attributes_form.fields[0]
  end


  it "should be able to select a Hash of field attributes" do
    @text_form.get_group(:text_field)[:field].should == "<input type='text' name='text_field' id='id_text_field' />"
  end

  it "should be able to select individual label tags" do
    @text_form.get_group(:text_field)[:label_tag].should == "<label for='id_text_field'>Herp some derps</label>"
  end

  it "should be able to get individual fields" do
    @text_form.get(:field, :text_field).should == "<input type='text' name='text_field' id='id_text_field' />"
  end

  it "should be able to get individual labels" do
    @text_form.get(:label_tag, :text_field).should == "<label for='id_text_field'>Herp some derps</label>"
  end

  it "should wrap fields with <p> tags by default" do
    @text_form.to_html.should == "<p>#{@text_field.to_labeled_html}</p>\n"
  end

  it "should wrap fields with anything else on request" do
    @text_form.to_html(:span).should == "<span>#{@text_field.to_labeled_html}</span>\n"
    @text_form.to_html(:div).should == "<div>#{@text_field.to_labeled_html}</div>\n"
  end

  it "should accept a hash of attributes for the wrapping tag" do
    @text_form.to_html(:p, {:class => :some_herps}).should == "<p class='some_herps'>#{@text_field.to_labeled_html}</p>\n"
    @text_form.to_html(:p, {:class => :some_herps, :id => "le_id"}).should == "<p class='some_herps' id='le_id'>#{@text_field.to_labeled_html}</p>\n"
  end

  it "should accept overrides to the defaults" do
    @default_attributes_form.to_html.should == "<span class='some_herps'>#{@text_field.to_labeled_html}</span>\n"
  end

end 
