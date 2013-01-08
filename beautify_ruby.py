import os.path
import sublime, sublime_plugin, sys, re
import subprocess

class BeautifyRubyOnSave(sublime_plugin.EventListener):
  def on_pre_save(self, view):
    self.settings = sublime.load_settings('BeautifyRuby.sublime-settings')
    if self.settings.get('run_on_save'):
      view.run_command("beautify_ruby", {"save": False, "error": False})

class BeautifyRubyCommand(sublime_plugin.TextCommand):
  def run(self, edit, error=True, save=True):
    self.settings = sublime.load_settings('BeautifyRuby.sublime-settings')
    if self.is_ruby_file():
      save = save and self.settings.get('save_on_beautify')
      self.get_selection_position()
      self.active_view = self.view.window().active_view()
      self.buffer_region = sublime.Region(0, self.active_view.size())
      # self.beautify_file()
      # self.view.window().run_command('refresh')
      self.update_view(self.beautify_buffer())
      if save:
        self.view.run_command('save')
      self.reset_selection_position()
    else:
      if error:
        sublime.error_message("This is not a Ruby file.")

  def beautify_file(self):
    save_document_if_dirty(self)
    subprocess.Popen(self.cmd(self.filename))

  def beautify_buffer(self):
    beautifier = subprocess.Popen(self.cmd(), shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    body = self.active_view.substr(self.buffer_region)
    out = beautifier.communicate(body)
    return out[0].decode('utf8')

  def update_view(self, contents):
    edit = self.view.begin_edit()
    self.view.erase(edit, self.buffer_region)
    self.view.insert(edit, 0, contents)
    self.view.end_edit(edit)

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

  def cmd(self, path = "-"):
    ruby_interpreter = self.settings.get('ruby') or "/usr/bin/env ruby"
    ruby_script  = os.path.join(sublime.packages_path(), 'BeautifyRuby', 'lib', 'rbeautify.rb')
    args = ["'" + unicode(path) + "'"]
    if self.settings.get('tab_or_space') != "space":
      args.insert(0, '-t')
    command = ruby_interpreter + " '" + ruby_script + "' " + ' '.join(args)
    return command

  def is_ruby_file(self):
    self.filename = self.view.window().active_view().file_name()
    fname         = os.path.basename(self.filename)
    file_patterns = self.settings.get('file_patterns') or ['.rb', '.rake']
    patterns = re.compile(r'\b(?:%s)\b' % '|'.join(file_patterns))
    if patterns.search(fname):
      return True
    else:
      return False
