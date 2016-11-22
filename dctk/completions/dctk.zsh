[[ -o interactive ]] || return 0

compctl -K _dctk dctk

_dctk() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(dctk commands)"
  else
    completions="$(dctk completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
