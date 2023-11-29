require 'launchy'

class DocumentationDSL
  
  PATH_FOR_CODE_BLOCKS = "for_code/code_file.txt"
  PATH_TO_DOC_FILE = "doc.html"

  def initialize
    @dictionary = {}
    @current_word = nil
    @document = []
  end


  def word(word, description)
    @dictionary[word] = description
  end


  def greet_user
    puts "\nWelcome to the Documentation Generator!"
  end


  def display_dictionary
    puts "\nDictionary:"
    @dictionary.each_with_index { |(word, _), index| puts "#{index + 1}. #{word}" }
  end


  def valid_word_index?(index)
    (1..@dictionary.size).cover?(index)
  end


  def select_word(index)
    if valid_word_index?(index)
      @current_word = @dictionary.keys[index - 1]
      puts "\nYou have chosen the word => #{@current_word}."
    else
      puts "\nInvalid input. Please select the correct number."
      display_dictionary
      print "\nSelect a word from the dictionary (enter number): "
      new_index = gets.chomp.to_i
      select_word(new_index) unless valid_word_index?(new_index)
    end
  end


  def valid_words_count?(count)
    count.positive?
  end


  def get_user_input(current_word)
    loop do
      print "\nEnter the number of words: "
      words_count = gets.chomp.to_i
      if valid_words_count?(words_count)
        puts "\nNow enter #{words_count} word(s) numbers"
        words_count.times do |i|
          print "Word #{i + 1}: "
          word = gets.chomp
          if(i == 0)
            @document.clear
          end
          @document << word
        end
        puts "Look at the html file"
        break
      else
        puts "\nInvalid input, please enter a positive number"
      end
    end
  end


  def get_user_section_heading()
    puts "\nEnter your heading: "
    heading = gets.chomp
    @document.clear
    @document << heading
  end


  def style_menu
    puts "\nChoose text style:"
    puts "1. Bold"
    puts "2. Italic"
    puts "3. Underline"
    puts "4. Strikethrough"
    puts "5. Subscript"
    puts "6. Superscript"
  
    choice = gets.chomp.to_i
  
    case choice
    when 1
      return "strong"  # жирный
    when 2
      return "em"      # курсив
    when 3
      return "u"       # подчеркнутый
    when 4
      return "s"       # зачеркнутый
    when 5
      return "sub"     # индекс
    when 6
      return "sup"     # степень
    else
      return nil        # если введен некорректный выбор
    end
  end


  def find_and_replace(text, search_term, style)
    index = text.downcase.index(search_term.downcase)
    if index
      modified_text = "#{text[0...index]}<#{style}>#{text[index...(index + search_term.length)]}</#{style}>#{text[(index + search_term.length)..-1]}"
      return modified_text
    else
      puts "\nWord/phrase not found in text"
    end
  end


  def get_user_text_with_style
    puts "\nEnter your text: "
    text = gets.chomp
  
    question = "Do you want to apply text styling?"
    if continue_generation(question)
      style = style_menu
      if(style)
        print "\nEnter a word or phrase to search: "
        search_term = gets.chomp
        text = find_and_replace(text, search_term, style) if style
      else
        puts "\nIncorrect option for style - so your text won't be changed"
      end
    end
  
    @document.clear
    @document << text
    generate_html_file(nil)
  end


  def check_image_exists(path)
    return File.exist?("img/#{path}")
  end


  def generate_metadata_for_html_file(author_name)
    File.open('doc.html', 'a') do |file|
      file.puts "<!DOCTYPE html>"
      file.puts "<html lang=\"en\">"
      file.puts "\t<head>"
      file.puts "\t\t<meta charset=\"UTF-8\">"
      file.puts "\t\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
      file.puts "\t\t<meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">"
      file.puts "\t\t<meta name=\"description\" content=\"My first documentation\">"
      file.puts "\t\t<meta name=\"author\" content=\"#{author_name}\">"
      file.puts "\t\t<link rel=\"shortcut icon\" href=\"icons/favicon.ico\">"
      file.puts "\t\t<link rel=\"stylesheet\" href=\"css/style.css\">"
      file.puts "\t\t<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/night-owl.css\">"
      file.puts "\t\t<script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js\"></script>"
      file.puts "\t\t<script>hljs.highlightAll();</script>"
      file.puts "\t\t<title>First project</title>"
      file.puts "\t</head>\n"
      file.puts "\t<body>"
    end
  end


  def generate_footer_for_html_file
    File.open('doc.html', 'a') do |file|
      file.puts "\t</body>\n"
      file.puts "</html>"
    end
  end


  def write_image_html(file, src, width, height, style)
    file.puts "\t\t\t<style>"
    file.puts "\t\t\t\t.fig {\n\t\t\t\t\ttext-align: #{style};"
    file.puts "\t\t\t\t}"
    file.puts "\t\t\t</style>\n"
    file.puts "\t\t\t<p class=\"fig\">"
    file.puts "\t\t\t\t<img src=\"#{src}\" alt=\"Picture must be here\" width=\"#{width}\" height=\"#{height}\">"
    file.puts "\t\t\t</p>"
  end


  def file_reader(file, path)
    lines = File.readlines(path)

    lines.each do |line|
      file.puts line
    end
  end


  def write_code_html(file)
    file.puts "\t\t\t<div class=\"code-editor\">"
    
    file.puts "\t\t\t\t<div class=\"circle circle-1\"></div>"
    file.puts "\t\t\t\t<div class=\"circle circle-2\"></div>"
    file.puts "\t\t\t\t<div class=\"circle circle-3\"></div>"

    file.puts "\t\t\t\t<pre class=\"line-numbers\" style=\"tab-size: 4;\">"
    file.puts "\t\t\t\t\t<code class=\"language-ruby\">"
    
    file_path = PATH_FOR_CODE_BLOCKS
    file_reader(file, file_path)
    
    file.puts "\t\t\t\t\t</code>"
    file.puts "\t\t\t\t</pre>"
    file.puts "\t\t\t</div>"
  end
  

  def generate_html_file(list_type)
    File.open(PATH_TO_DOC_FILE, 'a') do |file|
      case list_type
        when :unordered
          file.puts "\t\t\t<ul>"
        when :ordered
          file.puts "\t\t\t<ol>"
      end

      @document.each_with_index  do |word, index|
        case @current_word
        when "List"
          file.puts "\t\t\t\t<li><a href=\"##{word}\">#{word}</a></li>"
        when "Hr"
          file.puts "\t\t\t<hr>"
          break
        when "NumList", "BulletedList"
          file.puts "\t\t\t\t<li>#{word}</li>"
        when "Text"
          file.puts "\t\t\t<p>\n\t\t\t\t#{word}\n\t\t\t</p>"
        when "Heading"
          file.puts "\t\t\t<h2>#{word}</h2>"
        when "Code"
          write_code_html(file)
          break
        when "Picturetrue"
          src = word 
          width = @document[index+1] 
          height = @document[index+2]
          style = @document[index+3]
          write_image_html(file, src, width, height, style)
          break
        end
      end

    case list_type
      when :unordered
        file.puts "\t\t\t</ul>"
      when :ordered
        file.puts "\t\t\t</ol>"
      end
    end
  end


  def open_html_file
    Launchy.open(File.expand_path(PATH_TO_DOC_FILE, __dir__))
  end


  def continue_generation(question)
    puts "\n#{question} (y/n)"
    answer = gets.chomp.downcase
    answer == 'y'
  end


  def clear_screen
    system('clear') || system('cls')
  end


  def prompt_for_image_details
    puts "\nEnter the URL of the picture (without any folders):"
    image_path = gets.chomp
  
    width = prompt_for_numeric_input("Enter the width of the picture (e.g., 400):")
    height = prompt_for_numeric_input("Enter the height of the picture (e.g., 400):")
  
    puts "\nChoose the alignment for the picture:"
    puts "1. Center"
    puts "2. Left"
    puts "3. Right"
  
    alignment_choice = gets.chomp.to_i
  
    alignment = case alignment_choice
                when 1
                  "center"
                when 2
                  "left"
                when 3
                  "right"
                else
                  "center"
                end
  
    [image_path, width, height, alignment]
  end
  

  def prompt_for_numeric_input(prompt)
    loop do
      print "#{prompt} "
      input = gets.chomp
      return input.to_i if input.match?(/^\d+$/)
  
      puts "Invalid input. Please enter a numeric value."
    end
  end


  def update_document_and_current_word(image_details, flag)
    @document.clear
    src, width, height, style = image_details
    @document << "img/#{src}"
    @document << "#{width}px"
    @document << "#{height}px"
    @document << style
    @current_word = @current_word + flag.to_s
  end


  def validate_image_path(path)
    flag = check_image_exists(path)

    if !flag
      puts "\nIncorrect name of pic"
      return nil
    end

    flag
  end


  def prompt_for_hr
    @document.clear
    @document << "Hr"
    generate_html_file(nil)
  end


  def prompt_for_code_block
    puts "\nTo make a block of code, you need to enter it into the file \"for_code/code_file.txt\""
    if continue_generation("Have you already entered your code into this file?")
      @document.clear
      @document << "Code"
      generate_html_file(nil)
    else
      puts "\nOK. Nothing is written to the doc."
    end
  end


  def run(&block)
    loop do
      instance_eval(&block)
      question = "Wnat to continue?"
      print "\nSelect a word from the dictionary (enter number): "
      selected_word_index = gets.chomp.to_i

      if(!valid_word_index?(selected_word_index))
        puts "\nInvalid input, try again"  
        next 
      end

      select_word(selected_word_index)

      case selected_word_index
        when 1, 3, 4
          get_user_input(@current_word)
          generate_html_file((selected_word_index == 1 || selected_word_index == 4) ? (:unordered) : (:ordered))
        when 2
          prompt_for_hr
        when 5
          image_details = prompt_for_image_details
          flag = validate_image_path(image_details[0])
          if flag
            update_document_and_current_word(image_details, flag)
            generate_html_file(nil)
          else
            break unless continue_generation?
            clear_screen
            next
          end
        when 6
          get_user_section_heading
          generate_html_file(nil)
        when 7
          get_user_text_with_style
        when 8
          prompt_for_code_block
        else
          break
      end

      open_html_file
      break unless continue_generation(question)
      clear_screen
    end
  end

end


# Comment => another style of block of code
# <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/sunburst.css">