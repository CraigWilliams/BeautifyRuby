require 'htmlbeautifier'
module ERBeautify

  class << self
    def beautify(input, output, options = {})
      output.write(HtmlBeautifier.beautify(input, options))
    end

    def main
      if(!ARGV[0])
        STDERR.puts "usage: Ruby filenames or \"-\" for stdin."
        exit 0
      else
        path = ARGV.shift
        config = generate_config(ARGV)
        options = Hash.new
        translate_spaces_to_tabs = config['translate_tabs_to_spaces'] == 'False' ? { indent: "\t" } : Hash.new
        tab_size = (config['tab_size'].to_i != 0 and config['translate_tabs_to_spaces'] != 'False') ? { tab_stops: config['tab_size'].to_i } : Hash.new
        options = options.merge(tab_size).merge(translate_spaces_to_tabs)
        beautify $stdin.read.force_encoding('utf-8'), $stdout, options
      end
    end

    def generate_config args
      args.each_slice(2).with_object({}) do |parameter, result|
        result[parameter.first.gsub('--','').gsub('-','_')] = parameter.last
      end
    end
  end
end

# if launched as a standalone program, not loaded as a module
if __FILE__ == $0
  ERBeautify.main
end
