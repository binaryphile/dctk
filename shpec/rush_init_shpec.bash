source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)


describe "init"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"

    "$dir"/prepare rush >/dev/null

    define expected <<'EOS'
# Load rush automatically by adding
# the following to ~/.bash_profile:

eval "$(%s/rush init -)"
EOS

    # shellcheck disable=SC2030,SC2059
    printf -v expected "$expected" "$dir"/bin
    result=$("$dir"/bin/rush init 2>&1)
    # shellcheck disable=SC2016,SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message with input help"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"

    "$dir"/prepare rush >/dev/null

    define expected <<'EOS'
export PATH=$PATH:%q/bin
for file in %q/completions/*.bash; do
  source "$file"
done
unset -v file
EOS

    # shellcheck disable=SC2031,SC2059
    printf -v expected "$expected" "$dir" "$dir"
    result=$("$dir"/bin/rush init -)
    # shellcheck disable=SC2016
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
