source shpec-helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)

describe 'completions/rush.bash'
  it 'creates a _rush function'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    source "$dir"/completions/rush.bash
    # shellcheck disable=SC2154
    assert equal function "$(type -t _rush)"
    # shellcheck disable=SC2154
    $rm "$dir"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end
