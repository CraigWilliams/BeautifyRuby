import os.path
from os import popen
import sublime, sublime_plugin, sys, re

class BeautifyRubyCommand(sublime_plugin.TextCommand):
  def run(self, edit):
    self.settings = sublime.load_settings('BeautifyRuby.sublime-settings')
    self.filename = self.view.window().active_view().file_name()
    fname         = os.path.basename(self.filename)

    if self.is_ruby_file(fname):
      self.get_selection_position()
      self.save_document_if_dirty()

      beautified   = os.popen(self.cmd()).read()

      self.update_view(beautified.decode('utf8'))
      self.view.run_command('save')
      self.reset_selection_position()
    else:
      sublime.error_message("This is not a Ruby file.")

  def update_view(self, contents):
    active_view = self.view.window().active_view()
    body = active_view.substr(sublime.Region(0, active_view.size()))
    edit = active_view.begin_edit()
    active_view.erase(edit, sublime.Region(0, active_view.size()))
    active_view.insert(edit, 0, contents)
    active_view.end_edit(edit)

  def reset_selection_position(self):
    self.view.sel().clear()
    self.view.sel().add(self.region)
    self.view.show_at_center(self.region)

  def get_selection_position(self):
    sel         = self.view.sel()[0].begin()
    pos         = self.view.rowcol(sel)
    target      = self.view.text_point(pos[0], 0)
    self.region = sublime.Region(target)

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
    ruby_script  = os.path.join(sublime.packages_path(), 'BeautifyRuby', 'lib', 'rbeautify.rb')
    tab_or_space = self.tab_or_space_setting()
    ruby_interpreter = self.settings.get('ruby') or "/usr/bin/env ruby"
    command = ruby_interpreter + " '" + ruby_script + "' '" + tab_or_space + "'" + " '" + unicode(self.filename) + "'"
    return command

  def is_ruby_file(self, fname):
    patterns = re.compile(r'\.rb|\.rake')
    if patterns.search(fname):
      return True
    else:
      return False