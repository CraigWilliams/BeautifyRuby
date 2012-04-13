#Update
  2012-04-08
  Now aligns arguments within parens "()" on multiple lines.
  eg.

  ```ruby
    calling_a_method(
      arg_one,
      arg_two,
      etc
    )
  ```

  2012-04-05

  Now handles ruby interpreter configuration under settings

  2012-02-03

  Added BeautifyRuby to Edit menu item and cmd+shift+p command pallet

  2012-01-30

  Added setting to use a tab instead of two spaces. Also considers 'rake' files ruby files.

  2012-01-24

  Now handles ascii characters.

  2012-01-22

  Removed a ':' that was causing an error.

  2012-01-21

  To avoid potential data loss, the document saves before and after running beautifier.

  2012-01

  Changed key binding so it did not interfere with opening the side panel.

# BeautifyRuby

Beautifies Ruby code. This plugin uses the [Ruby Script Beautifier](http://www.arachnoid.com/ruby/rubyBeautifier.html) written by P.Lotus

I made very little modification to get it to work with a Sublime Text 2 plugin.

### Key Binding

```
  ctrl + cmd + k on OS X, or ctrl + alt + k on Windows
```

If your file turns blank you can configure your ruby interpreter under Preferences -> Package Settings -> BeautifiRuby -> Settings Default

I do

```
  which ruby
```

and place that in the ruby setting.

On windows, set Preferences -> Package Settings -> BeautifiRuby -> Settings Default

```
  "ruby": "ruby"
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
