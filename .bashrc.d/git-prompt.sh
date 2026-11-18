# Git branch/status in the prompt, using the git-prompt.sh that ships with
# Fedora's git package. Only shows inside a git repo.
#
#   fedora-mega:~/dot-files rjolley (master *+%=)$
#
#   *  unstaged changes      +  staged changes     %  untracked files
#   $  stash present         =  in sync with upstream
#   >  ahead of upstream     <  behind             <> diverged

if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    . /usr/share/git-core/contrib/completion/git-prompt.sh

    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUPSTREAM=auto

    # same layout as the old Mac prompt (\h:\w \u$), git info in green
    PS1='\h:\w \u\[\e[32m\]$(__git_ps1 " (%s)")\[\e[0m\]\$ '
fi

# Inside screen: dynamic window titles. The window is named after the command
# running in it (vim, claude, ...) and goes back to "sh" at the prompt. This
# also replaces Fedora's default user@host:dir title. (screen 5.0.1's own
# shelltitle '$ |' auto-title doesn't work, so bash sets the title itself.)
__screen_cmd_title() {
    local words
    read -ra words <<< "$(HISTTIMEFORMAT= history 1 | sed -E 's/^ *[0-9]+\*? *//')"
    # skip sudo (and its options) and VAR=value prefixes
    while [[ ${words[0]} == sudo || ${words[0]} == -* || ${words[0]} == *=* ]]; do
        words=("${words[@]:1}")
    done
    printf '\033k%s\033\\' "${words[0]##*/}"
}
case "$TERM" in
    screen*)
        PROMPT_COMMAND='printf "\033ksh\033\\"'
        PS0='$(__screen_cmd_title)'
        ;;
esac
