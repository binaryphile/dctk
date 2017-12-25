set -o nounset

source kaizen.bash imports='absolute_dirname get'

absolute_dirname "$BASH_SOURCE"
bin=$__/../bin

describe "dctk command"
  it "outputs a message with no input"; ( _shpec_failures=0
    result=$("$bin"/dctk)
    get <<'    EOS'
      Usage: dctk <command> [<args>]

      Some useful dctk commands are:
        commands  List all dctk commands

      See 'dctk help <command>' for information on a specific command.
    EOS
    assert equal "$__" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message with input help"; ( _shpec_failures=0
    result=$("$bin"/dctk help)
    get <<'    EOS'
      Usage: dctk <command> [<args>]

      Some useful dctk commands are:
        commands  List all dctk commands

      See 'dctk help <command>' for information on a specific command.
    EOS
    assert equal "$__" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
