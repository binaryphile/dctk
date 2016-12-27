source shpec-helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname root)
root=$(absolute_path "$root"/../..)
bin=$root/dctk/bin

source "$bin"/dctk

describe 'dctk_exports'
  it 'sets the _DCTK_ROOT environment variable'; (
    dctk_exports
    assert equal "$root"/dctk "$(printenv _DCTK_ROOT)"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end

describe 'find_command'
  it 'finds a command in libexec'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    touch "$dir"/file
    chmod +x "$dir"/file
    result=$(find_command file dir)
    assert equal "$dir"/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it "doesn't find a command not there"; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    find_command file dir
    assert unequal 0 $?
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the first command in a non-libexec root'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/dir1
    $mkdir "$dir"/dir2
    touch "$dir"/dir2/file
    chmod +x "$dir"/dir2/file
    result=$(find_command file "$dir"/dir1 "$dir"/dir2)
    assert equal "$dir"/dir2/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the command under bin in a non-libexec root'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/dir1
    $mkdir "$dir"/dir2/bin
    touch "$dir"/dir2/bin/file
    chmod +x "$dir"/dir2/bin/file
    result=$(find_command file "$dir"/dir1 "$dir"/dir2)
    assert equal "$dir"/dir2/bin/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end
end

describe 'is_structured'
  it 'detects a structured directory with bin'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/bin
    is_structured dir
    assert equal 0 $?
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'detects a structured directory with libexec'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/libexec
    is_structured dir
    assert equal 0 $?
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end
end

describe 'search_roots'
  it 'finds a command in a single root dir'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    touch "$dir"/file
    chmod +x "$dir"/file
    result=$(search_roots file [0]="$dir")
    assert equal "$dir"/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds a command in a second root dir'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    $mkdir "$dir"/dir1
    $mkdir "$dir"/dir2
    touch "$dir"/dir2/file
    chmod +x "$dir"/dir2/file
    result=$(search_roots file "[0]=$dir/dir1 [1]=$dir/dir2")
    assert equal "$dir"/dir2/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it "doesn't find a non-existent file"; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    $mkdir "$dir"/dir1
    $mkdir "$dir"/dir2
    search_roots file "[0]=$dir/dir1 [1]=$dir/dir2" >/dev/null
    assert unequal 0 $?
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end
end

describe 'structured_search'
  it 'finds the command in an unstructured root'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"
    touch "$dir"/file
    chmod +x "$dir"/file
    result=$(structured_search file dir)
    assert equal "$dir"/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it "doesn't find a non-existent command in an unstructured root"; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"
    structured_search file dir >/dev/null
    assert unequal 0 $?
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the command under bin in a structured root with bin'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/bin
    touch "$dir"/bin/file
    chmod +x "$dir"/bin/file
    result=$(structured_search file dir)
    assert equal "$dir"/bin/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the command under bin in a structured root with a root conflict'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    touch "$dir"/file
    chmod +x "$dir"/file
    $mkdir "$dir"/bin
    touch "$dir"/bin/file
    chmod +x "$dir"/bin/file
    result=$(structured_search file dir)
    assert equal "$dir"/bin/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the command under libexec in a structured root with libexec'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/bin
    touch "$dir"/bin/file
    chmod +x "$dir"/bin/file
    result=$(structured_search file dir)
    assert equal "$dir"/bin/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the command under bin in a structured root with both dirs'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/bin
    $mkdir "$dir"/libexec
    touch "$dir"/bin/file
    chmod +x "$dir"/bin/file
    result=$(structured_search file dir)
    assert equal "$dir"/bin/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the command under libexec in a structured root with both dirs'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/bin
    $mkdir "$dir"/libexec
    touch "$dir"/libexec/file
    chmod +x "$dir"/libexec/file
    result=$(structured_search file dir)
    assert equal "$dir"/libexec/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the command under bin in a structured root with both commands'; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/bin
    $mkdir "$dir"/libexec
    touch "$dir"/bin/file
    chmod +x "$dir"/bin/file
    touch "$dir"/libexec/file
    chmod +x "$dir"/libexec/file
    result=$(structured_search file dir)
    assert equal "$dir"/bin/file "$result"
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it "doesn't find a non-existent command in a structured root"; (
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    # shellcheck disable=SC2154
    $mkdir "$dir"/bin
    structured_search file dir >/dev/null
    assert unequal 0 $?
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end
end
