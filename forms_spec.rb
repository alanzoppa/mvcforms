require './forms'

describe "Low level Field behavior" do

  before do
    class DerpForm < Form
      @@derp_field = TextField.new("Herp some derps")
      @@radio = RadioField.new("Male", "male", "sex")
    end
    @test_field = DerpForm.new.fields[0]
    @radio_field = DerpForm.new.fields[1]
  end

  it "should assign its id based on the class variable name" do
    @test_field.name.should == :derp_field
  end

  it "should be able to template basic field types" do
    @test_field.to_html.should == "<input type='text' name='derp_field' id='id_derp_field' />"
  end

  it "should generate its own labels" do
    @test_field.label.should == "<label for='id_derp_field'>Herp some derps</label>"
    @test_field.label_text.should == "Herp some derps"
  end

  it "should create radio sub fields" do
    @radio_field.to_labeled_html.should == "<input type='radio' name='sex' id='id_sex_male' value='male'><label for='id_sex_male'>Male</label>"
  end

  #it "should support radio buttons" do
    #class GenderForm < Form
      #gender_options = [ { :value => "male", :label => "Male", },
                         #{ :value => "female", :label => "Female", }, ]

      #@@sex = RadioChoiceField.new(gender_options, :checked => :checked,)
    #end
    #@gender_form = GenderForm.new

    #@gender_form.fields.should == [
      #"<input type='radio' name='sex' value='male' />",
      #"<input type='radio' name='sex' value='female' />"
    #]


#<fieldset>
#<input type="radio" name="group1" id="rad1" value="1"><label for="rad1">button one</label>
#<input type="radio" name="group1" id="rad2" value="2"><label for="rad2">button two</label>
#<input type="radio" name="group1" id="rad3" value="3">klabel for="rad3">button three</label>
#</fieldset>


  #end

end


describe "Low level Form behavior" do

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
