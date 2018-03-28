## Generate live templates

```
ruby -Ilib -e "require 'generator'; Generator.dump_all! "

#adjust for your RM location/version
cp out/*.xml $HOME/Library/Preferences/RubyMine2017.1/templates/
```
