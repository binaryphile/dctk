set -o nounset

source kaizen.bash imports='absolute_dirname get'
absolute_dirname "$BASH_SOURCE"
libexec=$__/../libexec

describe commands
  it "outputs a message with no input"; ( _shpec_failures=0
    result=$("$libexec"/commands)
    get <<'    EOS'
      commands
      completions
      help
      init
    EOS
    assert equal "$__" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message with input help"; ( _shpec_failures=0
    get <<'    EOS'
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
