source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)


describe "rush hello"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

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

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
