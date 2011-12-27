import os.path
from os import popen
import sublime, sublime_plugin

class BeautifyRubyCommand(sublime_plugin.TextCommand):
  def run(self, edit):
    ext = os.path.basename(self.view.file_name())

    if ext.endswith(".rb"):
      ruby_script  = self.ruby_script()
      current_file = self.view.file_name()
      args         = "/usr/bin/ruby '" + ruby_script + "' '" + unicode(current_file) + "'"
      beautified   = os.popen(args).read()

      self.update_view(beautified)
    else:
      sublime.error_message("This is not a Ruby file.")

  def ruby_script(self):
    return os.path.join(sublime.packages_path(), 'BeautifyRuby', 'Ruby', 'beautifier.rb')

  def update_view(self, contents):
    body = self.view.window().active_view().substr(sublime.Region(0, self.view.window().active_view().size()))
    edit = self.view.window().active_view().begin_edit()
    self.view.window().active_view().erase(edit, sublime.Region(0, self.view.window().active_view().size()))
    self.view.window().active_view().insert(edit, 0, contents)
    self.view.window().active_view().end_edit(edit)
