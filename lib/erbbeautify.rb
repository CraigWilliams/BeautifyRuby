require 'htmlbeautifier'

def beautify(input, output)
  output.write(HtmlBeautifier.beautify(input))
end

beautify $stdin.read.force_encoding('utf-8'), $stdout
