set -o nounset

source concorde.bash globals=get
libexec=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")/../libexec

describe commands
  it "outputs a message with no input"; ( _shpec_failures=0
    result=$("$libexec"/commands)
    $get expected <<'    EOS'
      commands
      completions
      help
      init
    EOS
    assert equal "$__" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message with input help"; ( _shpec_failures=0
    $get <<'    EOS'
      commands
      completions
      help
      init
    EOS
    result=$("$libexec"/commands help)
    assert equal "$__" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
