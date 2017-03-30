[ ![Codeship Status for CraigWilliams/BeautifyRuby](https://www.codeship.io/projects/09898c30-f89d-0130-ede5-7a7e050a0c1a/status)](https://www.codeship.io/projects/6700)

# BeautifyRuby

Erb html templates uses [Paul Battley's htmlbeautifier gem](https://github.com/threedaymonk/htmlbeautifier). This (as well as rubygems) is assumed to be installed as seen by the ruby interpreter. Note that if you beautify an erb file but `htmlbeautifier` is not found, the error message is 'check your ruby interpreter settings', do not be misled.

### Interpreter settings

If an error is encountered while processing the file, Python receives an empty string and the following message is displayed but may have nothing to do with your Ruby settings.

```
check your ruby interpreter settings
```

### Hooks

This package offers a pre-save hook, i.e., your ruby and erb files will be reformatted automatically before saving. To activate this feature, set:

    "run_on_save": true,

The sublime command "beautify_ruby" performs a save after formatting. You can disable this default by setting:

    "save_on_beautify": false

You can change the file patterns handled by this plugin in the settings:

    "file_patterns": [ "\\.html\\.erb", "\\.rb", "\\.rake", "Rakefile", "Gemfile" ],
    "html_erb_patterns": ["\\.html\\.erb"],

This plugin uses ruby scripts to beautify your buffer, so it needs ruby installed. You can configure your ruby interpreter under Preferences -> Package Settings -> BeautifyRuby -> Settings Default/User. Although the default should work on linux and osx, not setting this right is a common problem.

If you do not use the system ruby, type in your favourite shell:

```
  which ruby
```

and place that in the ruby setting.

On windows, set Preferences -> Package Settings -> BeautifyRuby -> Settings Default

```
  "ruby": "ruby"
```

If you use project-specific rubies and gem sets managed with `rvm`, then simply set

      "ruby": "~/.rvm/bin/rvm-auto-ruby",

and then the `htmlbeautifier` gem is found even if it is only installed for this project.

### Tabs or Spaces

By default, Sublime does not translate tabs to spaces. If you wish to use tabs you will not need to change your settings. If you wish to use spaces, add the following setting.

```
"translate_tabs_to_spaces": true
```

Or if you wish to force the use of tabs use:

```
"translate_tabs_to_spaces": false
```
### Tab size

Sublime's default `tab_size` is set to 4. Override this setting to change the number of spaces to use when using spaces instead of tabs.

```
"tab_size": 2
```

### Key Binding

```
  ctrl + cmd + k on OS X, or ctrl + alt + k on Windows
```

# Installation

### Package Control
Using [Package Control](http://wbond.net/sublime_packages/package_control), a
package manager for Sublime Text 2.

In ST2, press "cmd + shift + p" and then type "install".

Once you see "Package Control: Install Package", enter.

When the packages load, another selection window will appear. Type

BeautifyRuby and enter. All done!

### Manual Installation

```bash
  cd "~/Library/Application Support/Sublime Text 2/Packages/"
  git clone git://github.com/CraigWilliams/BeautifyRuby.git
```
