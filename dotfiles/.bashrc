#  The following incantation allows easy group modification of files.
#  See here: http://en.wikipedia.org/wiki/Umask
#
#     umask 002 allows only you to write (but the group to read) any new
#     files that you create.
#
#     umask 022 allows both you and the group to write to any new files
#     which you make.
#
#  In general we want umask 022 on the server and umask 002 on local
#  machines.
#
#  The command 'id' gives the info we need to distinguish these cases.
#
#     $ id -gn  #gives group name
#     $ id -un  #gives user name
#     $ id -u   #gives user ID
#
#  So: if the group name is the same as the username OR the user id is not
#  greater than 99 (i.e. not root or a privileged user), then we are on a
#  local machine (check for yourself), so we set umask 002.
#
#  Conversely, if the default group name is *different* from the username
#  AND the user id is greater than 99, we're on the server, and set umask
#  022 for easy collaborative editing.
if [ "`id -gn`" == "`id -un`" -a `id -u` -gt 99 ]; then
  umask 002
else
  umask 022
fi

#  Set various bash parameters based on whether the shell is 'interactive'
#  or not.  An interactive shell is one you type commands into, a
#  non-interactive one is the bash environment used in scripts.
if [ "$PS1" ]; then

  if [ -x /usr/bin/tput ]; then
    if [ "x`tput kbs`" != "x" ]; then # We can't do this with "dumb" terminal
      stty erase `tput kbs`
    elif [ -x /usr/bin/wc ]; then
      if [ "`tput kbs|wc -c `" -gt 0 ]; then # We can't do this with "dumb" terminal
        stty erase `tput kbs`
      fi
    fi
  fi
  case $TERM in
    xterm*)
      if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
        PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
      else
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
      fi
      ;;
    screen)
      if [ -e /etc/sysconfig/bash-prompt-screen ]; then
        PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      else
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
      fi
      ;;
    *)
      [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default

      ;;
  esac

  # This snippet allows infinite recording of every command you've ever
  # entered on the machine, without using a large HISTFILESIZE variable,
  # and keeps track if you have multiple screens and ssh sessions into the
  # same machine. It is adapted from:
  # http://www.debian-administration.org/articles/543.
  #
  # The way it works is that after each command is executed and
  # before a prompt is displayed, a line with the last command (and
  # some metadata) is appended to ~/.bash_eternal_history.
  #
  # This file is a tab-delimited, timestamped file, with the following
  # columns:
  #
  # 1) user
  # 2) hostname
  # 3) screen window (in case you are using GNU screen)
  # 4) date/time
  # 5) current working directory (to see where a command was executed)
  # 6) the last command you executed
  #
  # The only minor bug: if you include a literal newline or tab (e.g. with
  # awk -F"\t"), then that will be included verbatime. It is possible to
  # define a bash function which escapes the string before writing it; if you
  # have a fix for that which doesn't slow the command down, please submit
  # a patch or pull request.
  PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo -e $$\\t$USER\\t$HOSTNAME\\tscreen $WINDOW\\t`date +%D%t%T%t%Y%t%s`\\t$PWD"$(history 1)" >> ~/.bash_eternal_history'

  # Update window size after every command
  shopt -s checkwinsize

  #Prompt edited from default
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u \w]\\$ "

  if [ "x$SHLVL" != "x1" ]; then # We're not a login shell
    for i in /etc/profile.d/*.sh; do
      if [ -r "$i" ]; then
        . $i
      fi
    done
  fi
fi

# Append to history
# See: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
shopt -s histappend

# Make prompt informative
# See:  http://www.ukuug.org/events/linux2003/papers/bash_tips/
PS1="\[\033[0;34m\][\u@\h:\w]$\[\033[0m\]"

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind "Space:magic-space"

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

# Save multi-line commands as one command
shopt -s cmdhist

# Record each line as it gets issued
PROMPT_COMMAND='history -a'

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Useful timestamp format
HISTTIMEFORMAT='%F %T '

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here:
# http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working
# directory, in home and in the ~/projects folder
CDPATH="."

# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it
# regardless of the directory you're in
shopt -s cdable_vars

# Examples:
# export dotfiles="$HOME/dotfiles"
# export projects="$HOME/projects"
# export documents="$HOME/Documents"
# export dropbox="$HOME/Dropbox"

# Safety
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# Listing, directories, and motion
alias ll="ls -alrtF --color"
alias la="ls -A"
alias l="ls -CF"
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias m='less'
alias ..='cd ..'
alias ...='cd ..;cd ..'
alias md='mkdir'
alias cl='clear'
alias du='du -ch --max-depth=1'
alias treeacl='tree -A -C -L 2'
alias extip='curl http://ipecho.net/plain; echo'

# Development 
alias vim='vim +NERDTree'
alias glog='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)"'

# grep options
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;31' # green for matches

# sort options
# Ensures cross-platform sorting behavior of GNU sort.
# http://www.gnu.org/software/coreutils/faq/coreutils-faq.html#Sort-does-not-sort-in-normal-order_0021
unset LANG
export LC_ALL=POSIX

# Install rlwrap if not present
# http://stackoverflow.com/a/677212
command -v rlwrap >/dev/null 2>&1 || { echo >&2 "Install rlwrap to use node: sudo apt-get install -y rlwrap";}

# node.js and nvm
# http://nodejs.org/api/repl.html#repl_repl
alias node="env NODE_NO_READLINE=1 rlwrap node"
alias node_repl="node -e \"require('repl').start({ignoreUndefined: true})\""
export NODE_DISABLE_COLORS=1
if [ -s ~/.nvm/nvm.sh ]; then
  NVM_DIR=~/.nvm
  source ~/.nvm/nvm.sh
  nvm use v0.10.12 &> /dev/null # silence nvm use; needed for rsync
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## Define any user-specific variables you want here.
source ~/.bashrc_custom

