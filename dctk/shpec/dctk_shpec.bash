export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p -- "$TMPDIR"

set -o nounset

source kaizen.bash imports='bring'
source "$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")"/../bin/dctk
$(bring '
  chmod
  mkdir
  mktempd
  rmtree
  touch
' from kaizen.commands)

describe find_command
  it "finds a command in libexec"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $touch "$dir"/file
    $chmod +x "$dir"/file
    find_command file "$dir"
    assert equal "$dir"/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "doesn't find a command not there"; ( _shpec_failures=0
    dir=$($mktempd) || return
    find_command file "$dir"
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the first command in a non-libexec root"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/dir1
    $mkdir "$dir"/dir2
    $touch "$dir"/dir2/file
    $chmod +x "$dir"/dir2/file
    find_command file "$dir"/dir1 "$dir"/dir2
    assert equal "$dir"/dir2/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the command under bin in a non-libexec root"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/dir1
    $mkdir "$dir"/dir2/bin
    $touch "$dir"/dir2/bin/file
    $chmod +x "$dir"/dir2/bin/file
    find_command file "$dir"/dir1 "$dir"/dir2
    assert equal "$dir"/dir2/bin/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe structured?
  it "detects a structured directory with bin"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/bin
    structured? "$dir"
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "detects a structured directory with libexec"; ( _shpec_failures=0
    dir=$($mktempd) || return 1
    $mkdir "$dir"/libexec
    structured? "$dir"
    assert equal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe search_roots
  it "finds a command in a single root dir"; ( _shpec_failures=0
    dir=$($mktempd) || return
    touch "$dir"/file
    $chmod +x "$dir"/file
    search_roots file "$dir"
    assert equal "$dir"/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds a command in a second root dir"; ( _shpec_failures=0
    dir=$($mktempd) || return 1
    $mkdir "$dir"/dir1
    $mkdir "$dir"/dir2
    touch "$dir"/dir2/file
    $chmod +x "$dir"/dir2/file
    search_roots file "$dir"/dir1 "$dir"/dir2
    assert equal "$dir"/dir2/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "doesn't find a non-existent file"; ( _shpec_failures=0
    dir=$($mktempd) || return 1
    $mkdir "$dir"/dir1
    $mkdir "$dir"/dir2
    search_roots file "$dir"/dir1 "$dir"/dir2
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe structured_search
  it "finds the command in an unstructured root"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"
    touch "$dir"/file
    $chmod +x "$dir"/file
    structured_search file "$dir"
    assert equal "$dir"/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "doesn't find a non-existent command in an unstructured root"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"
    structured_search file "$dir"
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the command under bin in a structured root with bin"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/bin
    $touch "$dir"/bin/file
    $chmod +x "$dir"/bin/file
    structured_search file "$dir"
    assert equal "$dir"/bin/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the command under bin in a structured root with a root conflict"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $touch "$dir"/file
    $chmod +x "$dir"/file
    $mkdir "$dir"/bin
    $touch "$dir"/bin/file
    $chmod +x "$dir"/bin/file
    structured_search file "$dir"
    assert equal "$dir"/bin/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the command under libexec in a structured root with libexec"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/bin
    touch "$dir"/bin/file
    $chmod +x "$dir"/bin/file
    structured_search file "$dir"
    assert equal "$dir"/bin/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the command under bin in a structured root with both dirs"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/bin
    $mkdir "$dir"/libexec
    $touch "$dir"/bin/file
    $chmod +x "$dir"/bin/file
    structured_search file "$dir"
    assert equal "$dir"/bin/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the command under libexec in a structured root with both dirs"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/bin
    $mkdir "$dir"/libexec
    $touch "$dir"/libexec/file
    $chmod +x "$dir"/libexec/file
    structured_search file "$dir"
    assert equal "$dir"/libexec/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "finds the command under bin in a structured root with both commands"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/bin
    $mkdir "$dir"/libexec
    $touch "$dir"/bin/file
    $chmod +x "$dir"/bin/file
    $touch "$dir"/libexec/file
    $chmod +x "$dir"/libexec/file
    structured_search file "$dir"
    assert equal "$dir"/bin/file "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "doesn't find a non-existent command in a structured root"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $mkdir "$dir"/bin
    structured_search file "$dir"
    assert unequal 0 $?
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
