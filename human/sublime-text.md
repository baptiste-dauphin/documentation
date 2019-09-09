# Sublime-text
### Preparing package installation
Before, you can download and install awesome packages, you first have to install the __Package Control package__. It's dumb, but it's not included in sublime-text installation...

The simplest method of installation is through the Sublime Text console. The console is accessed via the __ctrl+\`__ shortcut or the __View > Show Console__ menu. Once open, paste the appropriate Python code for your version of Sublime Text into the console. 

```python
import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by) 
```
[official source](https://packagecontrol.io/installation)
This code creates the Installed Packages folder for you (if necessary), and then downloads the Package Control.sublime-package into it. The download will be done over HTTP instead of HTTPS due to Python standard library limitations, however the file will be validated using SHA-256.


### Install a package (__insp__)
Open __commande palette__
```
ctrl + shift + p
```
Then, open __sublime-text package manager__, select __Package Control: Install package__ by shortname __insp__
```
insp
```
Then, enter

### My packages

Name | Usage | __insp__ name| URL
----|----|-----|------
Markdown Preview | To see a preview of your README.md files before commit them | `MarkdownPreview` | https://facelessuser.github.io/MarkdownPreview/install/
Compare Side-By-Side | Compares two tabs | `Compare Side-By-Side` | https://packagecontrol.io/packages/Compare%20Side-By-Side
Generic Config | Syntax generic config colorization |
PowerCursors | multiple cursors placements |
Materialize | Nice theme
MarkdownPreview | Preview your .md file 


### Shortcut
Name | shortcut
-----|---------
Jump at a specific line | `ctrl + G`
Switch previous / next tab | `ctrl + shift + page_up` \ `ctrl + shift + page_down`
Switch to a specific tab | `ctrl + p`, and write name of your tab (file)
Move a line or a block of line | `ctrl + shift + arrow up` \ `ctrl + shift + arrow down`
Switch upper case | `Ctrl + k` and then `Ctrl + u`
Switch lower case | `Ctrl + k` and then `Ctrl + l`