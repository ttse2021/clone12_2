#
# Setup the PATH variable
#

ENV=$HOME/.kshrc

#
# Add to PATH variable
#
export PATH=$PATH:/usr/lib/instl/

# Invoke a local profile if one exists
#
if [ -f $HOME/.profile.local ] ; then . $HOME/.profile.local; fi

