source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)
libexec=$root/libexec
bin=$root/bin


describe "init"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
# Load dctk automatically by adding
# the following to ~/.bash_profile:

eval "$(%s/dctk init -)"
EOS

    # shellcheck disable=SC2030,SC2059
    printf -v expected "$expected" "$bin"
    result=$("$libexec"/init 2>&1)
    # shellcheck disable=SC2016,SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message with input help"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
export PATH=$PATH:%s
source %s/completions/dctk.bash
EOS

    # shellcheck disable=SC2031,SC2059
    printf -v expected "$expected" "$bin" "$root"
    result=$("$libexec"/init -)
    # shellcheck disable=SC2016
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
