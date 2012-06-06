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

require File.dirname(__FILE__) + '/rbeautify/block_start.rb'
require File.dirname(__FILE__) + '/rbeautify/block_end.rb'
require File.dirname(__FILE__) + '/rbeautify/block_matcher.rb'
require File.dirname(__FILE__) + '/rbeautify/language.rb'
require File.dirname(__FILE__) + '/rbeautify/line.rb'

require File.dirname(__FILE__) + '/rbeautify/config/ruby.rb'

module RBeautify

  def self.beautify_string(language, source, use_tabs=false)
    dest = ""
    block = nil

    unless language.is_a? RBeautify::Language
      language = RBeautify::Language.language(language)
    end

    source.split("\n").each_with_index do |line_content, line_number|
      line = RBeautify::Line.new(language, line_content, line_number, block, use_tabs)
      dest += line.format + "\n"
      block = line.block
    end

    return dest
  end

  def self.beautify_file(path, backup = false)
    if(path == '-') # stdin source
      source = STDIN.read
      print beautify_string(:ruby, source)
    else # named file source
      source = File.read(path)
      dest = beautify_string(:ruby, source)
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
  end # beautify_file

  def self.beautify_sublime(path, use_tabs)
    source = File.read( path)
    dest = beautify_string(:ruby, source, use_tabs)
    STDOUT.write(dest)
    STDOUT.flush
  end # beautify_sublime

  def self.main
    if(!ARGV[0])
      STDERR.puts "usage: Ruby filenames or \"-\" for stdin."
      exit 0
    elsif(ARGV[0] =~ /^space$|^tab$/) # called from Sublime Text 2
      beautify_sublime(ARGV[1], ARGV[0] == 'tab')
    else # called from commandline
      ARGV.each { |path| beautify_file(path) }
    end
  end # main


end # module RBeautify

# if launched as a standalone program, not loaded as a module
if __FILE__ == $0
  RBeautify.main
end
