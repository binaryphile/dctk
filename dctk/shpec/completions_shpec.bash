set -o nounset

source kaizen.bash imports='absolute_dirname get'
absolute_dirname "$BASH_SOURCE"
libexec=$__/../libexec
source "$libexec"/completions

describe completions
  it "outputs a message with input help"; ( _shpec_failures=0
    result=$("$libexec"/completions help)
    get <<'    EOS'
      commands
      completions
      help
      init
    EOS
    assert equal "$__" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it 'looks for the leading comment'; ( _shpec_failures=0
    stub_command grep 'command grep -i "${@:2}"'
    stub_command exec :
    result=$(main help)
    assert equal "# Completions: true" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "doesn't return a completion for completions"; ( _shpec_failures=0
    result=$("$libexec"/completions completions)
    assert equal '' "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
