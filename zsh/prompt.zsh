setopt PROMPT_SUBST

function git_prompt_info {
  local ref=$(=git symbolic-ref HEAD 2> /dev/null)
  local gitst="$(=git status 2> /dev/null)"
  local pairname=${${${GIT_AUTHOR_EMAIL#pair+}%@github.com}//+/\/}
  local branchChar='*'
  if [[ ${pairname} == 'ch' || ${pairname} == '' ]]; then
    pairname=''
  else
    pairname=" ($pairname)"
  fi

  if [[ -f .git/MERGE_HEAD ]]; then
    if [[ ${gitst} =~ "unmerged" ]]; then
      gitstatus=" %{$fg[red]%}unmerged%{$reset_color%}"
    else
      gitstatus=" %{$fg[green]%}merged%{$reset_color%}"
    fi
  elif [[ ${gitst} =~ "Changes to be committed" ]]; then
    gitstatus=" %{$fg_bold[blue]%}$branchChar%{$reset_color%}"
  elif [[ ${gitst} =~ "use \"git add" ]]; then
    gitstatus=" %{$fg_bold[red]%}$branchChar%{$reset_color%}"
  elif [[ -n `git checkout HEAD 2> /dev/null | grep ahead` ]]; then
    gitstatus=" %{$fg_bold[yellow]%}$branchChar%{$reset_color%}"
  else
    gitstatus=''
  fi

  if [[ -n $ref ]]; then
    echo "%F{white}$(echo ${ref#refs/heads/} \
        | sed 's/^/%F{gray}/' \
        | sed 's/_/ /g' \
        | sed 's/^%F{gray}Story\//%F{green}/' \
        | sed 's/^%F{gray}Bug\//%F{yellow}/' \
        | sed 's/#\([0-9]\+\)\//[#\1] %F{gray}/')%{$reset_color%}$gitstatus$pairname"
  fi
}

function getPathPrompt {
    local gitRootDir=$(=git rev-parse --show-toplevel 2> /dev/null | sed "s;^$HOME;~;")
    local cwd=$(=pwd | sed "s;^$HOME;~;")
    if [ "$gitRootDir" ]; then
        local gitRootName=$(=basename $gitRootDir)
        local beforeGitRoot=$(=echo $gitRootDir | sed "s;$gitRootName\$;;")

        cwd=$(=echo $cwd | sed "s;^$gitRootDir;;")

        echo "%F{blue}$beforeGitRoot%F{red}$gitRootName%F{blue}$cwd "
    else
        echo "%F{blue}$cwd"
    fi
}

NEW_LINE=$'\n'

vim_ins_mode="%F{red}>%F{yellow}>%F{green}>%f"
vim_cmd_mode="%F{green}»%F{yellow}»%F{red}»%f"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

function TRAPUSR1() {
  vim_mode=$vim_ins_mode
  zle && zle reset-prompt
}

PROMPT='${NEW_LINE}$(getPathPrompt)%{$reset_color%}$(git_prompt_info)${NEW_LINE}${vim_mode}%{${reset_color}%} '
RPROMPT=''

