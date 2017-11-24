export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"

set -o nounset

source concorde.bash
$(bring '
  cptree
  dirname
  mktempd
  readlink
  rmtree
' from concorde.commands)

root=$($dirname "$($readlink "$BASH_SOURCE")")/..

describe prepare
  it "outputs a message with no input"; ( _shpec_failures=0
    result=$("$root"/prepare 2>&1)
    assert equal $'\nusage: prepare name_of_your_dctk' "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message with an input name"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $cptree "$root"/* "$dir"
    cd "$dir"
    get <<'    EOS'
      Preparing your 'name' trapper-keeper!
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
    expected=$'\n'${__// }
    result=$("$dir"/prepare name)
    assert equal "$expected" "${result// }"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "removes top-level files"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $cptree "$root"/* "$dir"
    cd "$dir"
    "$dir"/prepare name >/dev/null 2>&1
    result=$(find "$dir" -maxdepth 1 -type f -print)
    assert equal '' "$result"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "renames bin/dctk"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $cptree "$root"/* "$dir"
    cd "$dir"
    result=$("$dir"/prepare name)
    [[ -h "$dir"/bin/name ]]
    assert equal '(0) (../dctk/bin/dctk)' "($?) ($(readlink "$dir"/bin/name))"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "renames completions/dctk"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $cptree "$root"/* "$dir"
    cd "$dir"
    result=$("$dir"/prepare name)
    assert equal '(../dctk/completions/dctk.bash) (../dctk/completions/dctk.zsh)' "($(readlink "$dir"/completions/name.bash)) ($(readlink "$dir"/completions/name.zsh))"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "creates a name directory"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $cptree "$root"/* "$dir"
    cd "$dir"
    result=$("$dir"/prepare name)
    [[ -d "$dir/name" ]]
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
