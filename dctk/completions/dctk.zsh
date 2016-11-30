name=${(%):-%x}
name=${name##*/}
name=${name%.*}

compctl -K _"$name" "$name"

read -rd "" func <<'EOS' ||:
_%s() {
  local word
  local words
  local completions

  read -cA words
  word="${words[2]}"

  if (( ${#words} == 2 )); then
    completions=$(%s commands)
  else
    completions=$(%s completions "$word")
  fi

  reply=("${(ps:\n:)completions}")
}
EOS

eval "$(printf "$func" "$name" "$name" "$name")"

unset -v func
unset -v name
