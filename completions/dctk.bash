[[ $- == *i* ]] || return 0

_dctk() {
  local command
  local completions
  local word=${COMP_WORDS[COMP_CWORD]}

  COMPREPLY=()

  if (( COMP_CWORD == 1 )); then
    COMPREPLY=( $(compgen -W "$(dctk commands)" -- "$word") )
  else
    command=${COMP_WORDS[1]}
    completions=$(dctk completions "$command")
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _dctk dctk
