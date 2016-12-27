declare name=${BASH_SOURCE##*/}
name=${name%.*}

declare func
read -rd "" func <<'EOS' ||:
_%s() {
  local command
  local completions
  local word=${COMP_WORDS[COMP_CWORD]}

  COMPREPLY=()

  if (( COMP_CWORD == 1 )); then
    COMPREPLY=( $(compgen -W "$(%s commands)" -- "$word") )
  else
    command=${COMP_WORDS[1]}
    completions=$(%s completions "$command")
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}
EOS

# shellcheck disable=SC2059
eval "$(printf "$func" "$name" "$name" "$name")"

complete -F _"$name" "$name"

unset -v func name
