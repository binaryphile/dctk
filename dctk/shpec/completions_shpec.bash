set -o nounset

source concorde.bash globals=get
libexec=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")/../libexec
source "$libexec"/completions

describe completions
  it "outputs a message with input help"; ( _shpec_failures=0
    result=$("$libexec"/completions help)
    $get <<'    EOS'
      commands
      completions
      help
      init
    EOS
    assert equal "$__" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  # it 'looks for the leading comment'; (
  #   # shellcheck disable=SC2016
  #   stub_command grep 'echo "$2"'
  #   stub_command exec ':'
  #   result=$(completions_main help)
  #   # shellcheck disable=SC2154
  #   assert equal "# completions: true" "$result"
  #   return "$_shpec_failures" )
  # end
  #
  # it "doesn't return a completion for completions"; (
  #   result=$("$libexec"/completions completions)
  #   # shellcheck disable=SC2154
  #   assert equal "" "$result"
  #   return "$_shpec_failures" )
  # end
end
