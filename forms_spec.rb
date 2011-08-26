$test_env = true
require './forms'
require 'nokogiri'

describe "A Low level TextField" do

  before do
    class DerpForm < Form
      @@derp_field = TextField.new("Herp some derps")
    end
    @derp_field = DerpForm.new.fields[0]
  end

  it "should assign its name based on the class variable name" do
    @derp_field._noko_first(:input)[:name].should == 'derp_field'
  end

  it "should assign its id based on the class variable name" do
    @derp_field._noko_first(:input)[:id].should == 'id_derp_field'
  end

  it "should base the field type on the assigning class" do
    @derp_field._noko_first(:input)[:type].should == 'text'
  end

  it "should be able to template basic field types" do
    @derp_field.to_html.should == "<input type='text' name='derp_field' id='id_derp_field' />"
  end

  it "should generate its own labels" do
    @derp_field.label_tag.should == "<label for='id_derp_field'>Herp some derps</label>"
    @derp_field.label_text.should == "Herp some derps"
  end

end

describe "A Low-level RadioField" do
  #tests low level behavior. RadioFields should not be used directly.

  before do
    class DerpForm < Form
      @@gender_choice = RadioField.new("Male")
    end
    @gender_choice = DerpForm.new.fields[1]
  end


  it "should have the radio type" do
    @gender_choice._noko_first(:input)[:type].should == "radio"
  end

  it "should be the class var name" do
    @gender_choice._noko_first(:input)[:name].should == "gender_choice"
  end

  it "should have a name-based id" do
    @gender_choice._noko_first(:input)[:id].should == "id_gender_choice_male"
  end

  it "should properly create label tags and associate them to the input tag" do
    @gender_choice._noko_label_tag[:for].should == 'id_gender_choice_male'
    @gender_choice._noko_label_tag[:for].should == @gender_choice._noko_first(:input)[:id]
  end

  it "should be aware of its label text" do
    @gender_choice.label_text.should == 'Male'
  end

  it "should generate inputs with associated labels" do
    @gender_choice.to_labeled_html.should == "<input type='radio' value='male' name='gender_choice' id='id_gender_choice_male' /><label for='id_gender_choice_male'>Male</label>"
  end

end

describe "The symbolize method" do
  it "should replace spaces with underscores" do
    symbolize("foo bar baz").should == :foo_bar_baz
  end
end


describe "A Low level Form" do

  before do
    class LoginForm < Form
      @@username = TextField.new("Username")
      @@password = TextField.new("Password", :class => :pw,)
      @@herp = "derp"
    end
    @login_form = LoginForm.new

  end

  it "should correctly report its fields in the defined order" do
    fields_as_strings = @login_form.fields.map {|f| f.to_html}
    fields_as_strings.should == [
      "<input type='text' name='username' id='id_username' />",
      "<input type='text' class='pw' name='password' id='id_password' />",
    ]
  end

  it "should accept a hash of attributes" do
    class OptInForm < Form
      @@future_communications = CheckboxField.new("Would you like to receive future communications", :checked => :checked, )
    end
    @opt_in_form = OptInForm.new

    fields_as_strings = @opt_in_form.fields.map {|f| f.to_html}
    fields_as_strings.should == [
      "<input type='checkbox' checked='checked' name='future_communications' id='id_future_communications' />"
    ]
  end

end


describe "A Form containing RadioFields" do
  before do
    class GenderForm < Form
      @@gender = RadioChoiceField.new(["Male", "Female"])
    end

    @gender_form = GenderForm.new
  end


  it "should generate a list of html options" do
    puts @gender_form.fields[0].class
    #@gender_form.fields[0]._html_options.should ==
      #"<option value='capulet'>Capulet</option><option value='montague'>Montague</option>"
  end


end


describe "A Form containing ChoiceFields" do
  before do
    class FamilyForm < Form
      @@surname = ChoiceField.new("Choose a family", ['Capulet', 'Montague'])
    end

    @family_form = FamilyForm.new
    @surname_field = @family_form.fields[0]
  end

  it "should generate a list of html options" do
    @surname_field._html_options.should == "<option value='capulet'>Capulet</option><option value='montague'>Montague</option>"
  end

  it "should generate a complete select field" do
    @surname_field.to_html.should == "<select name='surname' id='#{@surname_field.html_id}'>#{@surname_field._html_options}</select>"
  end

end

#<select name="license" id="id_license">
#<option value="capulet">Capulet</option>
#<option value="montague">Montague</option>
#</select>
