source shpec_helper.bash
initialize_shpec_helper

libexec=$(realpath "$BASH_SOURCE")
libexec=$(dirname "$libexec")
libexec=$(absolute_path "$libexec"/../libexec)

PATH=$libexec:$PATH


describe "dctk-commands"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
commands
completions
help
init
shell
EOS

    result=$("$libexec"/dctk-commands)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message with the --sh option"; ( _shpec_failures=0   # shellcheck disable=SC2030

    result=$("$libexec"/dctk-commands --sh)
    assert equal "shell" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message with the --no-sh option"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
commands
completions
help
init
EOS

    result=$("$libexec"/dctk-commands --no-sh)
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
shell
EOS

    result=$("$libexec"/dctk-commands help)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
