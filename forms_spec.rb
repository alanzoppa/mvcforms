require './forms'

describe "Low level Field behavior" do

  before do
    @f = Field.new(:input, :bar)
  end

  it "should be able to template basic field types" do
    @f.render.should == "<input type='text' name='bar' />"
  end

end


describe "Low level Form behavior" do

  before do
    class LoginForm < Form
      @@username = Field.new(:input, :username)
      @@password = Field.new(:input, :password)
    end
    @login_form = LoginForm.new
  end

  it "should correctly report its fields in the defined order" do
    fields_as_strings = @login_form.fields.map {|f| f.render}
    fields_as_strings.should == [
      "<input type='text' name='username' />",
      "<input type='text' name='password' />"
    ]

  end

end
