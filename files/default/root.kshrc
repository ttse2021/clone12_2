#
# Invoke a local kshrc if one exists
#
if [ -f $HOME/.kshrc.local ]; then . $HOME/.kshrc.local ; fi

if [[ -o interactive ]]; then
  example=foobar
fi
