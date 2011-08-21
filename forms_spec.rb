require './forms'

describe "Low level Field behavior" do

  before do
    class DerpForm < Form
      @@derp_field = Field.new(:text, {:name => :bar})
    end
    @test_field = DerpForm.new.fields[0]
  end

  it "should assign its id based on the class variable name" do
    @test_field.html_id.should == :derp_field
  end

  it "should be able to template basic field types" do
    @test_field.to_html.should == "<input type='text' name='bar' id='derp_field' />"
  end

end


describe "Low level Form behavior" do

  before do
    class LoginForm < Form
      @@username = Field.new(:text, :name => "username")
      @@password = Field.new(:text, :name => :password, :class => :pw)
    end
    @login_form = LoginForm.new

    class OptInForm < Form
      @@future_communications = Field.new(:checkbox, :checked => :checked, :name => :future_communications, )
    end
    @opt_in_form = OptInForm.new
  end

  it "should correctly report its fields in the defined order" do
    fields_as_strings = @login_form.fields.map {|f| f.to_html}
    fields_as_strings.should == [
      "<input type='text' name='username' id='username' />",
      "<input type='text' name='password' class='pw' id='password' />",
    ]
  end

  it "should accept a hash of attributes" do
    fields_as_strings = @opt_in_form.fields.map {|f| f.to_html}
    fields_as_strings.should == [
      "<input type='checkbox' checked='checked' name='future_communications' id='future_communications' />"
    ]
  end

end
