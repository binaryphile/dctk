source shpec-helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)

describe 'rush hello'
  it 'outputs a message with no input'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    echo "echo hello" >"$dir"/rush/hello
    chmod +x "$dir"/rush/hello
    assert equal hello "$("$dir"/bin/rush hello)"
    # shellcheck disable=SC2154
    $rm "$dir"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end

describe 'shur after rush'
  it 'outputs a message'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    # shellcheck disable=SC2154
    $ln ../dctk/bin/dctk "$dir"/bin/shur
    # shellcheck disable=SC2154
    $mkdir "$dir"/shur
    puts "echo hello" >"$dir"/shur/hello
    chmod +x "$dir"/shur/hello
    assert equal hello "$("$dir"/bin/shur hello)"
    # shellcheck disable=SC2154
    $rm "$dir"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end
