require_relative 'dsl'


documentation_dsl = DocumentationDSL.new
documentation_dsl.generate_metadata_for_html_file("Sabina, Sasha")
documentation_dsl.run do
  greet_user
  word("List", "List of href")
  word("Hr", "Horizontal Rule")
  word("NumList", "NumList of text")
  word("BulletedList", "BulletedList of text")
  word("Picture", "Attach picture")
  word("Heading", "Section heading")
  word("Text", "Section text")
  word("Code", "Block of code")
  display_dictionary
end
documentation_dsl.generate_footer_for_html_file