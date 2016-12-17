source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)

describe 'prepare'
  it 'outputs a message with no input'; (
    result=$("$root"/prepare 2>&1)
    assert equal 'usage: prepare name_of_your_dctk' "$result"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'outputs a message with an input name'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    defs expected <<'EOS'
      Preparing your 'name' dctk!
      Done! Enjoy your new trapper-keeper! If you're happy with your trapper-keeper,
      run:

          rm -rf .git
          git init
          git add .
          git commit -m 'Starting off name'
          ./bin/name init

      Made a mistake? Want to make a different trapper-keeper? Run:

          git add .
          git checkout -f

      Thanks for making a trapper-keeper!
EOS
    result=$("$dir"/prepare name)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'removes prepare'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    result=$("$dir"/prepare name)
    is_file "$dir"/prepare
    assert unequal 0 "$?"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'removes README'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    result=$("$dir"/prepare name)
    is_file "$dir"/README.md
    assert unequal 0 "$?"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'renames bin/dctk'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    result=$("$dir"/prepare name)
    is_symlink "$dir"/bin/dctk
    assert unequal 0 "$?"
    assert equal ../dctk/bin/dctk "$(readlink "$dir"/bin/name)"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end

  it 'renames completions/dctk'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    result=$("$dir"/prepare name)
    is_symlink "$dir"/completions/dctk.bash
    assert unequal 0 $?
    is_symlink "$dir"/completions/dctk.zsh
    assert unequal 0 $?
    assert equal ../dctk/completions/dctk.bash "$(readlink "$dir"/completions/name.bash)"
    assert equal ../dctk/completions/dctk.zsh "$(readlink "$dir"/completions/name.zsh)"
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" );
  end

  it 'creates a name directory'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    cp -r "$root"/* "$dir"
    cd "$dir"
    result=$("$dir"/prepare name)
    is_directory "$dir/name"
    assert equal 0 $?
    # shellcheck disable=SC2154
    $rm "$dir"
    return "$_shpec_failures" )
  end
end
