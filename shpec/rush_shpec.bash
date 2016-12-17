source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)

describe 'rush'
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
    result=$("$dir"/bin/rush)
    #shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'outputs a message with input help'; (
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
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end


  it 'sets the _RUSH_ROOT environment variable'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    source "$dir"/bin/rush
    assert equal "$dir"/rush "$_RUSH_ROOT"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end
end
