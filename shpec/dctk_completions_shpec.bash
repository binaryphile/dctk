source shpec_helper.bash
initialize_shpec_helper

libexec=$(realpath "$BASH_SOURCE")
libexec=$(dirname "$libexec")
libexec=$(absolute_path "$libexec"/../libexec)

PATH=$libexec:$PATH


describe "dctk-completions"
  it "outputs a message with input commands"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
--sh
--no-sh
EOS

    result=$("$libexec"/dctk-completions commands)
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

    result=$("$libexec"/dctk-completions help)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
