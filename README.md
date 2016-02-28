## Generate live templates

```
ruby -Ilib -e "require 'generator'; Generator.dump_all!"

#adjust for your RM location/version
cp out/*.xml /Users/<you>/Library/Preferences/RubyMine80/templates/
```
