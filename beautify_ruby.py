import os.path
from os import popen
import sublime, sublime_plugin, sys, re

class BeautifyRubyCommand(sublime_plugin.TextCommand):
  def run(self, edit):
    self.settings = sublime.load_settings('BeautifyRuby.sublime-settings')
    self.filename = self.view.window().active_view().file_name()
    fname         = os.path.basename(self.filename)

    if self.is_ruby_file(fname):
      self.save_document_if_dirty()

      beautified   = os.popen(self.cmd()).read()

      self.update_view(beautified.decode('utf8'))
      self.view.run_command('save')
    else:
      sublime.error_message("This is not a Ruby file.")

  def ruby_script(self):
    return os.path.join(sublime.packages_path(), 'BeautifyRuby', 'ruby', 'beautifier.rb')

  def update_view(self, contents):
    body = self.view.window().active_view().substr(sublime.Region(0, self.view.window().active_view().size()))
    edit = self.view.window().active_view().begin_edit()
    self.view.window().active_view().erase(edit, sublime.Region(0, self.view.window().active_view().size()))
    self.view.window().active_view().insert(edit, 0, contents)
    self.view.window().active_view().end_edit(edit)

  def save_document_if_dirty(self):
    if self.view.is_dirty():
      self.view.run_command('save')

  def tab_or_space_setting(self):
    tab_or_space = self.settings.get('tab_or_space')
    if tab_or_space == '':
      return 'space'
    else:
      return tab_or_space

  def cmd(self):
    ruby_script  = self.ruby_script()
    tab_or_space = self.tab_or_space_setting()
    return "/usr/bin/env ruby '" + ruby_script + "' '" + tab_or_space + "'" + " '" + unicode(self.filename) + "'"

  def is_ruby_file(self, fname):
    patterns = re.compile(r'\.rb|\.rake')
    if patterns.search(fname):
      return True
    else:
      return False