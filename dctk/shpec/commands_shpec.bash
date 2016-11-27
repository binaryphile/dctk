source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/../..)
libexec=$root/dctk/libexec


describe "commands"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
commands
completions
help
init
EOS

    result=$("$libexec"/commands)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message with input help"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
commands
completions
help
init
EOS

    result=$("$libexec"/commands help)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
