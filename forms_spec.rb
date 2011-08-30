require './test_module'
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


describe "A more complicated form with multiple fields" do

  before do
    class MoreComplicatedForm < Form
      @@description_of_derps = TextField.new("Herp some derps")
      @@gender_choice = RadioChoiceField.new("Choose your gender", ["Male", "Female"])
      @@cat = CheckboxField.new("Are you a cat?", :checked => :checked, )
      @@family = ChoiceField.new("Choose a family", ['Capulet', 'Montague', "Other"])

      def _define_defaults
        super
        @__settings[:wrapper] = :div
        @__settings[:wrapper_attributes] = {:class => "more_complicated"}
      end

    end

    @more_complicated_form = MoreComplicatedForm.new
    @description_of_derps_field = @more_complicated_form.get_field(:description_of_derps)
    @gender_choice_field = @more_complicated_form.get_field(:gender_choice)
    @cat_field = @more_complicated_form.get_group(:cat)[:field]
    @family_field = @more_complicated_form.get_field(:family)
  end

  it "should generate four <divs> with the class 'more_complicated'" do
    #print "\n"
    #print @more_complicated_form.to_html
    @more_complicated_form._noko_first(:div)[:class].should == "more_complicated"
    @more_complicated_form._noko_nth(:div, 1)[:class].should == "more_complicated"
    @more_complicated_form._noko_nth(:div, 2)[:class].should == "more_complicated"
    @more_complicated_form._noko_nth(:div, 3)[:class].should == "more_complicated"
  end

end
