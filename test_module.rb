require 'nokogiri'

module TestModule
  def _noko_first tag
    Nokogiri::HTML(self.to_html).search(tag)[0]
  end

  def _noko_label_tag
    Nokogiri::HTML(self.label_tag).search(:label)[0]
  end
end
