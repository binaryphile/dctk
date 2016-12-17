source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)

describe 'rush help'
  it 'outputs a message with no input'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    defs expected <<'EOS'
      Usage: rush <command> [<args>]

      Some useful rush commands are:
        commands  List all rush commands

      See 'rush help <command>' for information on a specific command.
EOS
    result=$("$dir"/bin/rush help)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'outputs a message for commands'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    defs expected <<'EOS'
      Usage: rush commands

      This command is mostly used for autocompletion in various shells, and for `rush help`.
EOS
    result=$("$dir"/bin/rush help commands)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'outputs a message for completions'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    result=$("$dir"/bin/rush help completions)
    assert equal "Sorry, this command isn't documented yet." "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'outputs a message for help'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    result=$("$dir"/bin/rush help help)
    assert equal "Sorry, this command isn't documented yet." "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'outputs a message for init'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    result=$("$dir"/bin/rush help init)
    assert equal "Sorry, this command isn't documented yet." "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end
end
