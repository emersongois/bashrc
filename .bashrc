# =================================================================== #
#
# PERSONAL $HOME/.bashrc FILE for bash-3.0 (or later)
# By Emerson Gois 
# Email: emerson.gois@gmail.com
# Based on .bashrc file created by Emmanuel Rouat
# Tested on Slackware 14.1
#
# Last modified: 27-Jun-2016 13:30:29 
#
# This file is normally read by interactive shells only.
# + Here is the place to define your aliases, functions and
# + other interactive features like your prompt.
#
# The majority of the code here assumes you are on a GNU
# + system (most likely a Linux box) and is often based on code
# + found on Usenet or Internet.
#
# See for instance:
# http://tldp.org/LDP/abs/html/index.html
# http://www.caliban.org/bash
# http://www.shelldorado.com/scripts/categories.html
# http://www.dotfiles.org
#
# The choice of colors was done for a shell with a dark background
# + (white on black), and this is usually also suited for pure text-mode
# + consoles (no X server available). If you use a white background,
# + you'll have to do some other choices for readability.
#
# =================================================================== #



# ------------------------------------------------------------------- #
# CHECK INTERACTIVE SHELL
# ------------------------------------------------------------------- #

# If not running interactively, don't do anything
[ -z "$PS1" ] && return



# ------------------------------------------------------------------- #
# SOURCE GLOBAL DEFINITIONS (IF ANY)
# ------------------------------------------------------------------- #

if [ -f /etc/bashrc ]; then
	. /etc/bashrc # --> Read /etc/bashrc, if present.
fi



# ------------------------------------------------------------------- #
# SOME SETTINGS FOR SHELL OPTIONS (SHOPT) 
# ------------------------------------------------------------------- #

#set -o nounset			# These two options are useful for debugging.
#set -o xtrace
alias debug="set -o nounset; set -o xtrace"

ulimit -S -c 0 			# Don't want coredumps.
set -o notify
set -o noclobber
set -o ignoreeof


# ENABLE OPTIONS
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob		# Necessary for programmable completion.

# DISABLE OPTIONS
shopt -u mailwarn
unset MAILCHECK       	# Do not receive warnings of incoming mail.



# ------------------------------------------------------------------- #
# COLOR DEFINITIONS
# ------------------------------------------------------------------- #

# Color definitions taken from Color Bash Prompt HowTo.
# Some colors might  look different of  some terminals,  for example, I 
# + see 'Bold Red' as 'Orange' on my screen, hence  the 'Green', 'BRed'
# + and 'Red' sequence I often use in my prompt.


# NORMAL COLORS
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# BOLD
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# BACKGROUND
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red}	# Bold White on red background



# ------------------------------------------------------------------- #
# GREETINGS, MESSAGE OF THE DAY, EXIT, ETC
# ------------------------------------------------------------------- #

# DATE
date

# HEADING
echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${NC}\n"

# MESSAGE OF THE DAY
if [ -x /usr/games/fortune ]; then
	/usr/games/fortune -s		# Makes our day a bit more fun.... :-)
fi

# FUNCTION ON EXIT SESSION
function _exit()				# Function to run upon exit of shell.
{
	echo -e "${BRed}Hasta la vista, baby${NC}"
	clear
}
trap _exit EXIT



# ------------------------------------------------------------------- #
# SHELL PROMPT
# ------------------------------------------------------------------- #

# EXAMPLES
# http://www.debian-administration.org/articles/205
# http://www.askapache.com/linux/bash-power-prompt.html
# http://tldp.org/HOWTO/Bash-Prompt-HOWTO
# https://github.com/nojhan/liquidprompt

# Current Format: [TIME USER@HOST PWD] >
# TIME:
#    Green     == machine load is low
#    Orange    == machine load is medium
#    Red       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    Cyan      == normal user
#    Orange    == SU to user
#    Red       == root
# HOST:
#    Cyan      == local session
#    Green     == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Green     == more than 10% free disk space
#    Orange    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    Red       == current user does not have write privileges
#    Cyan      == current filesystem is size zero (like /proc)
# >:
#    White     == no background or suspended jobs in this shell
#    Cyan      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').

# TEST CONNECTION TYPE
if [ -n "${SSH_CONNECTION}" ]; then
	CNX=${Green}		# Connected on remote machine, via ssh (GOOD).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
	CNX=${ALERT}		# Connected on remote machine, not ssh (BAD).
else
	CNX=${BCyan}		# Connected on local machine.
fi

# TEST USER TYPE
if [[ ${USER} == "root" ]]; then
	SU=${Red}					# User is root.
	ID="#"						# Identifier "#" for ROOT user.
elif [[ ${USER} != $(logname) ]]; then
	SU=${BRed}					# User is not login user.
else
	SU=${BCyan}					# User is normal.
	ID="$"						# Identifier "$" for NORMAL users.
fi

# PROCESSORS
NCPU=$(grep -c 'processor' /proc/cpuinfo)    # Number of CPUs
SLOAD=$(( 100*${NCPU} ))        # Small load
MLOAD=$(( 200*${NCPU} ))        # Medium load
XLOAD=$(( 400*${NCPU} ))        # Xlarge load

# FUNCTION RETURNS SYSTEM LOAD AS PERCENTAGE ('40' rather than '0.40')
function load()
{
	local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
	# System load of the current host.
	echo $((10#$SYSLOAD))       # Convert to decimal.
}

# FUNCTION RETURNS A COLOR INDICATING SYSTEM LOAD
function load_color()
{
	local SYSLOAD=$(load)
	if [ ${SYSLOAD} -gt ${XLOAD} ]; then
		echo -en ${ALERT}
	elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
		echo -en ${Red}
	elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
		echo -en ${BRed}
	else
		echo -en ${Green}
	fi
}

# FUNCTION RETURNS A COLOR ACCORDING TO FREE DISK SPACE IM PWD
function disk_color()
{
	if [ ! -w "${PWD}" ] ; then
		echo -en ${Red}
		# No 'write' privilege in the current directory.
	elif [ -s "${PWD}" ] ; then
		local used=$(command df -P "$PWD" |
			awk 'END {print $5} {sub(/%/,"")}')
		if [ ${used} -gt 95 ]; then
			echo -en ${ALERT}           # Disk almost full (>95%).
		elif [ ${used} -gt 90 ]; then
			echo -en ${BRed}            # Free disk space almost gone.
		else
			echo -en ${Green}           # Free disk space is ok.
		fi
	else
		echo -en ${Cyan}
		# Current directory is size '0' (like /proc, /sys etc).
	fi
}

# FUNCTION RETURNS A COLOR ACCORDING TO RUNNING SUSPENDED JOBS
function job_color()
{
	if [ $(jobs -s | wc -l) -gt "0" ]; then
		echo -en ${BRed}
	elif [ $(jobs -r | wc -l) -gt "0" ] ; then
		echo -en ${BCyan}
	fi
}

# ADD SOME TEXT IN THE TERMINAL FRAME (IF APPLICABLE)

# SETTING THE PROMPT 
PROMPT_COMMAND="history -a"
case ${TERM} in
	*term | rxvt | linux)
		#PS1="\[\$(load_color)\][\A\[${NC}\] "
		
		# TIME OF DAY (WITH LOAD INFO):
		#PS1="\[\$(load_color)\][\A\[${NC}\] "
		 PS1="\[\$(load_color)\]\n[\d, \t]\n[\[${NC}\]"
		
		# USER@HOST (WITH CONNECTION TYPE INFO):
		PS1=${PS1}"\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h:\[${NC}\]"
		
		# PWD (WITH 'DISK SPACE' INFO):
		PS1=${PS1}"\[\$(disk_color)\]\w]\[${NC}\] "
		
		# PROMPT (WITH 'JOB' INFO):
		PS1=${PS1}"\[\$(job_color)\]${ID}\[${NC}\] "
		
		# SET TITLE OF CURRENT XTERM:
		PS1=${PS1}"\[\e]0;[\u@\h] \w\a\]"
		;;
	*)
		PS1="(\A \u@\h \w) > " # --> PS1="(\A \u@\h \w) > "
        ;;
esac 



export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups
export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts


#============================================================
#
#  ALIASES AND FUNCTIONS
#
#  Arguably, some functions defined here are quite big.
#  If you want to make this file smaller, these functions can
#+ be converted into scripts and removed from here.
#
#============================================================

#-------------------
# Personnal Aliases
#-------------------

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'

# Pretty-print of some PATH variables:	
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

# ------------------------------------------------------------------- #
# The 'ls' family (this assumes you use a recent GNU ls).
# ------------------------------------------------------------------- #
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...


# ------------------------------------------------------------------- #
# Tailoring 'less'
# ------------------------------------------------------------------- #

alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
				# Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# ------------------------------------------------------------------- #
# Spelling typos - highly personnal and keyboard-dependent :-)
# ------------------------------------------------------------------- #

alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'


# ------------------------------------------------------------------- #
# A few fun ones
# ------------------------------------------------------------------- #

# Adds some text in the terminal frame (if applicable).

function xtitle()
{
	case "$TERM" in
	*term* | rxvt)
		echo -en  "\e]0;$*\a" ;;
	*)  ;;
	esac
}


# Aliases that use xtitle
alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'

# .. and functions
function man()
{
	for i ; do
		xtitle The $(basename $1|tr -d .[:digit:]) manual
		command man -a "$i"
	done
}


# ------------------------------------------------------------------- #
# PROCESS/SYSTEM RELATED FUNCTIONS
# ------------------------------------------------------------------- #

# FUNCTION RETURNS IP ADDRESS ON ETHERNET
function my_ip() 
{
	MY_IP=$(/sbin/ifconfig wlan0 | awk '/inet/ { print $2 } ' |
		sed -e s/addr://)
	echo ${MY_IP:-"Not connected"}
}

# FUNCTION RETURNS CURRENT HOST RELATED INFO
function ii()   
{
	echo -e "\nYou are logged on ${BRed}$HOST"
	echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
	echo -e "\n${BRed}Users logged on:$NC " ; w -hs | cut -d " " -f1 | sort | uniq
	echo -e "\n${BRed}Current date :$NC " ; date
	echo -e "\n${BRed}Machine stats :$NC " ; uptime
	echo -e "\n${BRed}Memory stats :$NC " ; free
	echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
	echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
	echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
	echo
}



# ------------------------------------------------------------------- #
# MISC UTILITIES FUNCTIONS
# ------------------------------------------------------------------- #

# FUNCTION REPEATS N TIMES A COMMAND
function repeat()
{
	local i max
	max=$1; shift;
	for ((i=1; i <= max ; i++)); do  # --> C-like syntax
		eval "$@";
	done
}


# Local Variables:
# mode:shell-script
# sh-shell:bash
# End:
