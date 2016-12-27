source shpec-helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)

describe 'rush commands'
  it 'outputs a message with no input'; (
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
    result=$("$dir"/bin/rush commands)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

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
    result=$("$dir"/bin/rush commands help)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end
end
