source shpec_helper.bash
initialize_shpec_helper

libexec=$(realpath "$BASH_SOURCE")
libexec=$(dirname "$libexec")
libexec=$(absolute_path "$libexec"/../libexec)

PATH=$libexec:$PATH


describe "dctk-help"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
Usage: dctk <command> [<args>]

Some useful dctk commands are:
   commands  List all dctk commands

See 'dctk help <command>' for information on a specific command.
EOS

    result=$("$libexec"/dctk-help)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message for commands"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
Usage: dctk commands

This command is mostly used for autocompletion in various shells, and for `dctk help`.
Also, this command helps find commands that are named the same as potentially builtin shell commands (which, cd, etc)
EOS

    result=$("$libexec"/dctk-help commands)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message for completions"; ( _shpec_failures=0   # shellcheck disable=SC2030

    result=$("$libexec"/dctk-help completions)
    assert equal "Sorry, this command isn't documented yet." "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message for help"; ( _shpec_failures=0   # shellcheck disable=SC2030

    result=$("$libexec"/dctk-help help)
    assert equal "Sorry, this command isn't documented yet." "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message for init"; ( _shpec_failures=0   # shellcheck disable=SC2030

    result=$("$libexec"/dctk-help init)
    assert equal "Sorry, this command isn't documented yet." "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message for sh-shell"; ( _shpec_failures=0   # shellcheck disable=SC2030

    result=$("$libexec"/dctk-help sh-shell)
    assert equal "Sorry, this command isn't documented yet." "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message for shell"; ( _shpec_failures=0   # shellcheck disable=SC2030

    result=$("$libexec"/dctk-help shell)
    assert equal "Sorry, this command isn't documented yet." "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
