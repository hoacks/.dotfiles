# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh
#setopt IGNORE_EOF
# Download Znap, if it's not there yet.
[[ -r ~/Repos/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh  # Start Znap

znap source marlonrichert/zsh-edit

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# 
source /home/joaco/.dotfiles/.aliases 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh



if [[ $- == *i* ]]; then
	bindkey -s '^g^d' '$(yw)\n^r'
#	bind '"\C-g\C-n": "$(yn)\e\C-e\er"'
#	bind '"\C-g\C-p": "$(yp)\e\C-e\er"'
#	bind '"\C-g\C-k": "$(yk)\e\C-e\er"'
#	bind '"\C-g\C-f": "$(fzp)\e\C-e\er"'
fi


export ST="/mnt/6TB/wordlist/"
export web_dicts_paths='/mnt/6T/wordlist/leaky-paths /mnt/6TB/wordlist/SecLists /home/joaco/wordlist/'
export nuclei_templates='/home/joaco/nuclei-templates'
export payloads_paths='${ST}PayloadsAllTheThings ${ST}SecLists'
export sqlmap_tamper_path='/home/joaco/tools/sqlmap-dev/tamper'
export bat_executable="~/.local/bin/bat"
export prev_window_str="--keep-right --preview-window right,40%"


yp() {
	# press ctrl-g then ctrl-p
	local find_files="find ${payloads_paths} -not -path '*/\.*' -type f | grep -P '\.txt$'"

	eval $find_files | fzf --select-1 --prompt 'Web Payload> ' ${prev_window_str} --reverse --preview "${bat_executable} --decorations=always --paging=always --style=numbers --color=always --line-range :100 {}" | sed -nr 's/^(.+)$/"\1"/pg'

}

yk() {
	# press ctrl-g then ctrl-k
	local find_workflows="find /home/joaco/workflows/ -not -path '*/\.*' -type f | grep -P '\.md$'"

	eval $find_workflows| fzf --select-1 --prompt 'My Workflows> ' ${prev_window_str} --reverse --preview "${bat_executable} --decorations=always --paging=always --style=numbers --color=always --line-range :100 {}" | sed -nr 's/^(.+)$/"\1"/pg'

}

yw() {
	# press ctrl-g then ctrl-d
	local find_files="find ${web_dicts_paths} -not -path '*/\.*' -type f | grep -P '\.txt$'"

	eval ${find_files} | fzf --select-1 --prompt 'Web Payload> ' ${prev_window_str} --reverse --preview "${bat_executable} --decorations=always --paging=always --style=numbers --color=always --line-range :100 {}" | sed -nr 's/^(.+)$/"\1"/pg'

}


yn() {
	# press ctrl-g then ctrl-n
	local find_files="find $nuclei_templates -not -path '*/\.*' -type f | grep -P '\.yaml$'"

	eval $find_files | fzf --select-1 --prompt 'Web Payload> ' ${prev_window_str} --reverse --preview "${bat_executable} --decorations=always --paging=always --style=numbers --color=always --line-range :100 {}" | sed -nr 's/^(.+)$/"\1"/pg'

}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Generated for pdtm. Do not edit.
export PATH=$PATH:/home/joaco/.pdtm/go/bin
export PATH=$PATH:/home/joaco/tools
export PATH=$PATH:/home/joaco/tools/scripts
export PATH=$PATH:$HOME/.axiom/interact


export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:/usr/local/go/bin


## CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

  # Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"



vivos()
{
cat domains | httpx -silent | tee  vivos

}

tamper() {
echo -n "$1: "; for i in GET POST HEAD PUT DELETE CONNECT OPTIONS TRACE PATCH ASDF; do echo "echo -n \"$i-$(curl -s -X $i $1 -o /dev/null -k -w '%{http_code}\n') \""; done | parallel -j 10 ; echo
}


scopeting(){
cat $1 | xargs -n1 -P35 bash -c 'j=$0; url="${j}"; curl -Lks -x http://127.0.0.1:8080 $url -A "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)" -m 4 1>/dev/null'
}



ajax_rain() { list="$(<$1) ending";
firefox --no-remote --profile /home/joaco/.mozilla/firefox/c34tgz12.ztv9h29d.fuzvjjue $list 2>&1 & }



bindkey -s ^f "tmux-sessionizer\n"
#bind  '"\C-i":"cht.sh\n"'

EDITOR=/usr/local/bin/nvim

resolver() {
    mkdir $2/resolver;
    cd /home/joaco/tools/bass/;
    python3 bass.py -d $1 -o $2/resolver/resolver-$1;
    cat $2/all-$1.txt | dnsgen - | massdns -r $2/resolver/resolver-$1.txt -t A -o J -w $2/resolver/dnsgen-$1.json;
}
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH
source /home/joaco/tools/BugBountyHuntingScripts/bbrf_helper.sh 
source /home/joaco/tools/BugBountyHuntingScripts/nuclei_helper.sh 
source /home/joaco/tools/BugBountyHuntingScripts/general_helper.sh 
source /home/joaco/tools/BugBountyHuntingScripts/axiom_helper.sh 
source /home/joaco/tools/BugBountyHuntingScripts/amass_helper.sh 
source /home/joaco/tools/BugBountyHuntingScripts/hackerone_helper.sh 
export WEBPASTE_TOKEN=ilovetomnomnom
#export http_proxy=127.0.0.1:8080
#export https_proxy=127.0.0.1:8080



alias elastic="docker compose -f /home/joaco/.dotfiles/work/elasticsearch/compose.yaml up -d"

cloud_recon() {
	cat ~/NAS/cloud_recon/*.txt | rg -F ".$1.com" | awk -F '--' '{print $2}' | tr ' ' '\n' | tr '[]' ' ' | rg -F ".$1.com" | sed 's/*.//' | sed 's/ //' | sort -u }

DIRSEARCH_CONFIG='/home/joaco/.config/dirsearch/config.ini'
alias vps_gh="vps tmux send-keys -t ReconAuto:gh_search \'gh_search.sh \$1 \' ENTER"


