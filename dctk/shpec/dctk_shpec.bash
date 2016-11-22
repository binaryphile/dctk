source shpec_helper.bash
initialize_shpec_helper

dctk=$(realpath "$BASH_SOURCE")
dctk=$(dirname "$dctk")
dctk=$(absolute_path "$dctk"/../dctk/dctk)


describe "dctk"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
Usage: dctk <command> [<args>]

Some useful dctk commands are:
   commands  List all dctk commands

See 'dctk help <command>' for information on a specific command.
EOS

    result=$("$dctk")
    #shellcheck disable=SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message with input help"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
Usage: dctk <command> [<args>]

Some useful dctk commands are:
   commands  List all dctk commands

See 'dctk help <command>' for information on a specific command.
EOS

    result=$("$dctk" help)
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
