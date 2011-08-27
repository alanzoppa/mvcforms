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

  #it "should be able to select individual fields" do
    #@derp_field.get_group(:derp_field)[:field].should == "<input type='text' name='derp_field' id='id_derp_field' />"
  #end

end




  #it "should be able to template basic field types" do
    #@derp_field.to_html.should == "<input type='text' name='derp_field' id='id_derp_field' />"
  #end

  #it "should generate its own labels" do
    #@derp_field.label_tag.should == "<label for='id_derp_field'>Herp some derps</label>"
    #@derp_field.label_text.should == "Herp some derps"
  #end


