$test_env = true
require './forms'
require 'nokogiri'

require "./fields_spec"
require "./helpers_spec"

describe "A Form with a TextField" do
  before do
    class DerpForm < Form
      @@derp_field = TextField.new("Herp some derps")
    end
    @derp_form = DerpForm.new
    @derp_field = DerpForm.new.fields[0]
  end

  it "should be able to select a Hash of field attributes" do
    @derp_form.get_group(:derp_field)[:field].should == "<input type='text' name='derp_field' id='id_derp_field' />"
  end

  it "should be able to select individual label tags" do
    puts @derp_form.get_group(:derp_field)[:label_tag].should == "<label for='id_derp_field'>Herp some derps</label>"
  end

  it "should be able to get individual fields" do
    @derp_form.get(:field, :derp_field).should == "<input type='text' name='derp_field' id='id_derp_field' />"
  end

  it "should be able to get individual labels" do
    puts @derp_form.get(:label_tag, :derp_field).should == "<label for='id_derp_field'>Herp some derps</label>"
  end

  it "should be able to get field instances" do
    @derp_form.get_field_instance(:derp_field).should == @derp_field
  end

end




  #it "should be able to template basic field types" do
    #@derp_field.to_html.should == "<input type='text' name='derp_field' id='id_derp_field' />"
  #end

  #it "should generate its own labels" do
    #@derp_field.label_tag.should == "<label for='id_derp_field'>Herp some derps</label>"
    #@derp_field.label_text.should == "Herp some derps"
  #end


