#!/usr/bin/ruby -w

=begin
/***************************************************************************
 *   Copyright (C) 2008, Joel Chippindale, Paul Lutus                      *
 *                                                                         *
 *   This program is free software: you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation, either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>. *
 *                                                                         *
 ***************************************************************************/
=end

require_relative './rbeautify/block_start.rb'
require_relative './rbeautify/block_end.rb'
require_relative './rbeautify/block_matcher.rb'
require_relative './rbeautify/language.rb'
require_relative './rbeautify/line.rb'
require_relative './rbeautify/tab_size.rb'
require_relative './rbeautify/config/ruby.rb'

module RBeautify

  class << self
    def beautify_string(language, source, config)
      dest = ""
      block = nil

      unless language.is_a? RBeautify::Language
        language = RBeautify::Language.language(language)
      end

      config['tab_size'] = RBeautify::TabSize.new(config).tab_size
      language.indent_size = config['tab_size']

      source.force_encoding("UTF-8").split("\n").each_with_index do |line_content, line_number|
        line = RBeautify::Line.new(language, line_content, line_number, block, config)
        dest += line.format + "\n"
        block = line.block
      end

      return dest
    end

    def beautify_file(path, config)
      backup = config["backup"] == 'True'

      if(path == '-') # stdin source
        source = STDIN.read
        print beautify_string(:ruby, source, config)
      else # named file source
        source = File.read(path)
        dest = beautify_string(:ruby, source, config)
        if(source != dest)
          if backup
            # make a backup copy
            File.open(path + "~","w") { |f| f.write(source) }
          end
          # overwrite the original
          File.open(path,"w") { |f| f.write(dest) }
        end
        return source != dest
      end
    end

    def main
      if(!ARGV[0])
        STDERR.puts "usage: Ruby filenames or \"-\" for stdin."
        exit 0
      else
        path = ARGV.shift
        config = generate_config(ARGV)
        beautify_file(path,config)
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
  RBeautify.main
end
