source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)


describe "prepare"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

    result=$("$root"/prepare 2>&1)
    assert equal "usage: prepare name_of_your_dctk" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message with an input name"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"

    define expected <<'EOS'
Preparing your 'name' dctk!
Done! Enjoy your new dctk! If you're happy with your dctk, run:

    rm -rf .git
    git init
    git add .
    git commit -m 'Starting off name'
    ./bin/name init

Made a mistake? Want to make a different dctk? Run:

    git add .
    git checkout -f

Thanks for making a dctk!
EOS

    result=$("$dir"/prepare name)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"

    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "removes prepare"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"

    result=$("$dir"/prepare name)

    is_file "$dir"/prepare
    assert unequal 0 "$?"

    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "removes README"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"

    result=$("$dir"/prepare name)

    ! is_file "$dir"/README.md
    assert equal 0 "$?"

    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "renames bin/dctk"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"

    result=$("$dir"/prepare name)

    ! is_symlink "$dir"/bin/dctk
    assert equal 0 "$?"

    assert equal ../dctk/name "$(readlink "$dir"/bin/name)"

    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "creates a name directory"; ( _shpec_failures=0   # shellcheck disable=SC2030

    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"

    result=$("$dir"/prepare name)

    is_directory "$dir/name"
    assert equal 0 $?

    # shellcheck disable=SC2154
    $rm "$dir"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
