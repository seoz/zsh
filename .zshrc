###############################################################################
# local variables to use
ZH=~/.zsh

###############################################################################
# some environment variables to set up
export HOSTNAME="`hostname`"
export LESS="-MM -R"

###############################################################################
# paths are scanned from these files
export            PATH=`awk '{printf("%s:",$1);}' < $ZH/path | sed 's:~:'$HOME':g'`:$PATH
export LD_LIBRARY_PATH=`awk '{printf("%s:",$1);}' < $ZH/libs | sed 's:~:'$HOME':g'`

SYNC_PATH=`cat $ZH/sync_files | awk '{printf("%s ", $1);}' | sed 's:~:'$HOME':g'`
export SYNC_PATH

###############################################################################
# term type - if we dont know the term type - set it to linux
if [ "$TERM" = "" -o "$TERM" = "unknown" ]; then
  export TERM=linux
fi

###############################################################################
# my prompt
 
 black='%{[30m%}'
 red='%{[31m%}'
 green='%{[32m%}'
 yellow='%{[33m%}'
 blue='%{[34m%}'
 purple='%{[35m%}'
 cyan='%{[36m%}'
 grey='%{[37m%}'
 bg_black='%{[40m%}'
 bg_red='%{[41m%}'
 bg_green='%{[42m%}'
 bg_yellow='%{[43m%}'
 bg_blue='%{[44m%}'
 bg_purple='%{[45m%}'
 bg_cyan='%{[46m%}'
 bg_grey='%{[47m%}'
 bright='%{[01m%}'
 underline='%{[04m%}'
 flashing='%{[05m%}'
 normal='%{[0m%}'
 
if [ -n "$SSH_TTY" ]; then
# SSH session
  if [ "$USER" = "root" ]; then
  # root
    export PROMPT=$bright$bg_purple$red'@ '$red'%t '$red'%~'$normal$bg_purple$bright$red' #'$normal' '
  else
  # me
    export PROMPT=$bright$bg_blue$cyan'@ '$grey'%t '$cyan'%~'$normal$bg_blue$bright$grey' >'$normal' '
  fi
else
# local session
  if [ "$USER" = "root" ]; then
  # root
    export PROMPT=$bright$bg_red$yellow'%t '$red'%~'$normal$bg_red$bright$yellow' #'$normal' '
  else
  # me
    export PROMPT=$bright$bg_green$yellow'%t '$cyan'%~'$normal$bg_green$bright$grey' >'$normal' '
  fi
fi

# prompt you get when you dont finish typing stuff...
export PS2=$bright$bg_purple$yellow'? '$red'>'$normal

###############################################################################
# function called before the prompt is displayed
function precmd {
# get a title at random from the title list
  if [ $TERM = xterm ]; then
    TLINES=`wc -l $ZH/titles | awk '{print $1;}'`
    TLINE=$[ ${RANDOM} % $TLINES ];
    TLINE=$[ $TLINE + 1 ];
    TITLE=`head -$TLINE < $ZH/titles | tail -1`
    echo -ne ']0;'$TITLE'\007'
  fi
}

###############################################################################
# misc settings
# num of times ctrl-d has to be pressed again to get zsh to exit
export IGNOREEOF=0
# set the default editor fc
#export FCEDIT=jed
# define which file sets up the interactive input settings
export INPUTRC=$ZH/input
# set this variable to something so "dot" files in a pathname are expanded
export glob_dot_filenames=1
# make sure zsh doesn't follow links in expansions
export nolinks=1
# history
export HISTSIZE=1024
export HISTFILESIZE=1024
# hostname completion
export HOSTFILE="/etc/hosts"
# set the umask
umask 022
# setup the dir colours
eval `dircolors -b $ZH/ls_colors`
# get my aliases
. $ZH/aliases
# My preferred editor
#export EDITOR=jed
# Jed settings
#if [ ! -f ~/.nojed ]; then
#  export JED_LIBRARY=~/.jed,/usr/lib/jed/lib
#  export JED_HOME=~/.jed
#fi
# just type directory name to cd to it
setopt AUTO_CD
# list all choices on an ambiguous completion
setopt AUTO_LIST
# after second completion attempt use a menu
setopt AUTO_MENU
# complete dirs with a / at the end
setopt AUTO_PARAM_SLASH
# dont run background jobs at a lower priority
setopt NO_BG_NICE
# if we cd to a dir that doesnt exist and its not starting with / try it in ~/
setopt CDABLE_VARS
# dont send HUP signales to jobs running if shell goes down
setopt NO_HUP
# notify me of bg jobs exiting immediately - not at next prompt
setopt NOTIFY
# extended globbing
setopt extendedglob

###############################################################################
# CVS stuff
export CVSROOT=enl@cvs.enlightenment.org:/cvs/e
export CVS_RSH=ssh

###############################################################################
# Compiler options
# my preferred compiler
export CC="`cat $ZH/cc`"
export CFLAGS="`cat $ZH/cflags`"
export CCACHE_NOSTATS=1
export CCACHE_HARDLINK=1

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

ulimit -c 100000

setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
setopt CORRECT
setopt EXTENDED_HISTORY
setopt MENUCOMPLETE
setopt ALL_EXPORT

#setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   notify globdots pushdtohome cdablevars autolist
#setopt   correctall autocd recexact longlistjobs
setopt   autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent 
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
#zmodload -ap zsh/mapfile mapfile

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"

autoload -U compinit
compinit
bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate

#### old stuff/notes
#zstyle -e ':completion:*:approximate:*' max-errors \
#    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
#    zstyle ':completion:*' select-prompt '%SScrolling active: current
#selection at %p%s'

# Completion Styles

# list of completers to use
#zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
#zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
        
# insert all expansions for expand completer
#zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
#zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
#zstyle ':completion:*' group-name ''

# match uppercase from lowercase
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
#zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
# zstyle ':completion:*:processes' command 'ps -au$USER'

## add colors to processes for kill completion
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

##zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
#zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
#zstyle ':completion:*:processes-names' command 'ps axho command' 
##zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
#
#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
#zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
# Filename suffixes to ignore during completion (except after rm command)
#zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
#zstyle ':completion:*:functions' ignored-patterns '_*'
#zstyle ':completion:*:*:*:users' ignored-patterns \
#  svn sync halt
  
# SSH Completion
#zstyle ':completion:*:scp:*' tag-order \
#   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
#zstyle ':completion:*:scp:*' group-order \
#   files all-files users hosts-domain hosts-host hosts-ipaddr
#zstyle ':completion:*:ssh:*' tag-order \
#   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
#zstyle ':completion:*:ssh:*' group-order \
#   hosts-domain hosts-host users hosts-ipaddr
#zstyle '*' single-ignored show

# notes...
#################################
# tidbits of ansi escapes etc....
# scroll from 10 to 20
# $LINES = lines
# SCROLLREG='[10;20r'
#  LL=$[ $LINES - 2];
#  echo '['$LL';'1'H'
#  echo '[1;'$LL'r'

export LANG=en_US.UTF-8
export LANGUAGE=$LANG
#export LC_ALL=$LANG
export LC_MESSAGES=$LANG
export XTERM_LOCALE=$LANG

# dont need atm
#export PYTHONPATH=$PYTHONPATH:$HOME/python/lib/python2.6/site-packages:/usr/lib/python2.7/dist-packages
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
#export GIT_PROXY_COMMAND=/usr/local/bin/gitproxy.sh
export PATH=$PATH:/home/seoz/script
