source shpec-helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)

describe 'rush structured hello command'
  it 'finds hello in bin'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    # shellcheck disable=SC2154
    $mkdir "$dir"/rush/bin
    puts "echo hello" >"$dir"/rush/bin/hello
    chmod +x "$dir"/rush/bin/hello
    assert equal hello "$("$dir"/bin/rush hello 2>/dev/null)"
    # shellcheck disable=SC2154
    $rm "$dir"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'finds hello in libexec'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    # shellcheck disable=SC2154
    $mkdir "$dir"/rush/libexec
    puts "echo hello" >"$dir"/rush/libexec/hello
    chmod +x "$dir"/rush/libexec/hello
    assert equal hello "$("$dir"/bin/rush hello 2>/dev/null)"
    # shellcheck disable=SC2154
    $rm "$dir"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'finds hello in bin when conflicting'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare rush >/dev/null
    # shellcheck disable=SC2154
    $mkdir "$dir"/rush/bin
    $mkdir "$dir"/rush/libexec
    puts "echo hello" >"$dir"/rush/bin/hello
    puts "echo nope" >"$dir"/rush/libexec/hello
    chmod +x "$dir"/rush/bin/hello
    chmod +x "$dir"/rush/libexec/hello
    assert equal hello "$("$dir"/bin/rush hello 2>/dev/null)"
    # shellcheck disable=SC2154
    $rm "$dir"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end
