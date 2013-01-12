require 'rubygems'
require 'htmlbeautifier'

# FIXME: Erb file should handle line endings too, expecially the last "\n"
def beautify(input, output)
  HtmlBeautifier::Beautifier.new(output).scan(input)
  output << "\n"
end

beautify $stdin.read, $stdout
