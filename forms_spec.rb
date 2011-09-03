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
      def redefine_defaults
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
    @text_form.to_html.should == "<p>\n  #{@text_field.to_labeled_html}\n</p>\n"
  end

  it "should wrap fields with anything else on request" do
    @text_form.to_html(:span).should == "<span>\n  #{@text_field.to_labeled_html}\n</span>\n"
    @text_form.to_html(:div).should == "<div>\n  #{@text_field.to_labeled_html}\n</div>\n"
  end

  it "should accept a hash of attributes for the wrapping tag" do
    @text_form.to_html(:p, {:class => :some_herps}).should == "<p class='some_herps'>\n  #{@text_field.to_labeled_html}\n</p>\n"
    @text_form.to_html(:p, {:class => :some_herps, :id => "le_id"}).should == "<p class='some_herps' id='le_id'>\n  #{@text_field.to_labeled_html}\n</p>\n"
  end

  it "should accept overrides to the defaults" do
    @default_attributes_form.to_html.should == "<span class='some_herps'>\n  #{@text_field.to_labeled_html}\n</span>\n"
  end

end 


describe "A more complicated form with multiple fields" do

  before do
    class MoreComplicatedForm < Form
      @@description_of_derps = TextField.new("Herp some derps")
      @@gender_choice = RadioChoiceField.new("Choose your gender", ["Male", "Female"])
      @@cat = CheckboxField.new("Are you a cat?", :checked => :checked, )
      @@family = ChoiceField.new("Choose a family", ['Capulet', 'Montague', "Other"])

      def redefine_defaults
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
    print "\n" + @more_complicated_form.to_html
    (0..3).each do |i|
      @more_complicated_form._noko_nth(:div, i)[:class].should == "more_complicated"
    end
  end

  it "should set pretty_print to true on all fields" do
    @more_complicated_form.fields.all? {|f| f.pretty_print == true }.should be_true
  end

  it "should produce a properly indented form" do
    @more_complicated_form.to_html.should == [
      "<div class='more_complicated'>",
      "  <label for='id_description_of_derps'>Herp some derps</label><input type='text' name='description_of_derps' id='id_description_of_derps' />",
      "</div>",
      "<div class='more_complicated'>",
      "  <label for='id_gender_choice'>Choose your gender</label>",
      "  <fieldset id='id_gender_choice'>",
      "    <legend>Choose your gender</legend>",
      "    <input value='male' type='radio' name='gender_choice' id='id_gender_choice_male' /><label for='id_gender_choice_male'>Male</label>",
      "    <input value='female' type='radio' name='gender_choice' id='id_gender_choice_female' /><label for='id_gender_choice_female'>Female</label>",
      "  </fieldset>",
      "</div>",
      "<div class='more_complicated'>",
      "  <input checked='checked' type='checkbox' name='cat' id='id_cat' /><label for='id_cat'>Are you a cat?</label>",
      "</div>",
      "<div class='more_complicated'>",
      "  <label for='id_family'>Choose a family</label>",
      "  <select id='id_family' name='family'>",
      "    <option value='capulet'>Capulet</option>",
      "    <option value='montague'>Montague</option>",
      "    <option value='other'>Other</option>",
      "  </select>",
      "</div>"].join("\n")
  end

end

describe "The same form without line breaks" do

  before do
    class CleanerForm < Form
      @@description_of_derps = TextField.new("Herp some derps")
      @@gender_choice = RadioChoiceField.new("Choose your gender", ["Male", "Female"])
      @@cat = CheckboxField.new("Are you a cat?", :checked => :checked, )
      @@family = ChoiceField.new("Choose a family", ['Capulet', 'Montague', "Other"])

      def redefine_defaults
        @__settings[:wrapper] = :div
        @__settings[:wrapper_attributes] = {:class => "more_complicated"}
        @__settings[:pretty_print] = false
      end

    end
    @cleaner_form = CleanerForm.new
  end

  it "should generate four <divs> with the class 'more_complicated'" do
    (0..3).each do |i|
      @cleaner_form._noko_nth(:div, i)[:class].should == "more_complicated"
    end
  end

  it "should print without line breaks" do
    @cleaner_form.to_html.match('\n').should be_nil
  end

  it "should print without spaces between tags" do
    @cleaner_form.to_html.match(/>\s+</).should be_nil
  end

  it "should set pretty_print to false on all fields" do
    @cleaner_form.fields.all? {|f| f.pretty_print == false }.should be_true
  end

end
