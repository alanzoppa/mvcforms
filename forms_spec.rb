$test_env = true
require './forms'
require 'nokogiri'

require "./fields_spec"
require "./helpers_spec"

describe "A Form with a TextField" do
  before do
    class TextFieldForm < Form
      @@text_field = TextField.new("Herp some derps")
    end
    @text_form = TextFieldForm.new
    @text_field = @text_form.fields[0]
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



  #it "should render the contents of <form> tags inside <p> tags" do
    #@text_form.to_form.should ==
      #"<p>"
  #end

end




  #it "should be able to template basic field types" do
    #@text_field.to_html.should == "<input type='text' name='text_field' id='id_text_field' />"
  #end

  #it "should generate its own labels" do
    #@text_field.label_tag.should == "<label for='id_text_field'>Herp some derps</label>"
    #@text_field.label_text.should == "Herp some derps"
  #end


