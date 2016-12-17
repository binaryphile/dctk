source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)

describe 'completions'
  it 'outputs a message with input help'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    defs expected <<'EOS'
      commands
      completions
      help
      init
EOS
    result=$("$dir"/bin/rush completions help)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it "doesn't scan non-script files"; ( _shpec_failures=0   # shellcheck disable=SC2030
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    source "$dir"/dctk/libexec/completions
    touch "$dir"/dctk/libexec/fake
    # shellcheck disable=SC2016
    stub_command grep 'echo "$2"'
    stub_command exec ':'
    result=$(main fake)
    # shellcheck disable=SC2154
    assert equal '' "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end
end
