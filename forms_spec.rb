require './forms'

describe "Low level Field behavior" do

  before do
    class DerpForm < Form
      @@derp_field = Field.new(:text, "Herp some derps")
    end
    @test_field = DerpForm.new.fields[0]
  end

  it "should assign its id based on the class variable name" do
    @test_field.name.should == :derp_field
  end

  it "should be able to template basic field types" do
    @test_field.to_html.should == "<input type='text' name='derp_field' id='id_derp_field' />"
  end

  it "should generate its own labels" do
    @test_field.label.should == "<label for='id_derp_field'>Herp some derps</label>"
  end

end


describe "Low level Form behavior" do

  before do
    class LoginForm < Form
      @@username = Field.new(:text, "Username")
      @@password = Field.new(:text, "Password", :class => :pw,)
    end
    @login_form = LoginForm.new

    class OptInForm < Form
      @@future_communications = Field.new(:checkbox, "Would you like to receive future communications", {:checked => :checked}, )
    end
    @opt_in_form = OptInForm.new
  end

  it "should correctly report its fields in the defined order" do
    fields_as_strings = @login_form.fields.map {|f| f.to_html}
    fields_as_strings.should == [
      "<input type='text' name='username' id='id_username' />",
      "<input type='text' class='pw' name='password' id='id_password' />",
    ]
  end

  it "should accept a hash of attributes" do
    fields_as_strings = @opt_in_form.fields.map {|f| f.to_html}
    fields_as_strings.should == [
      "<input type='checkbox' checked='checked' name='future_communications' id='id_future_communications' />"
    ]
  end

end
