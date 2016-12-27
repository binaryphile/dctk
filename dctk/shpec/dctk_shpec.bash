source shpec-helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/../..)
bin=$root/dctk/bin

describe 'dctk'
  it 'outputs a message with no input'
    defs expected <<'EOS'
      Usage: dctk <command> [<args>]

      Some useful dctk commands are:
         commands  List all dctk commands

      See 'dctk help <command>' for information on a specific command.
EOS
    result=$("$bin"/dctk)
    #shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
  end

  it 'outputs a message with input help'
    defs expected <<'EOS'
      Usage: dctk <command> [<args>]

      Some useful dctk commands are:
         commands  List all dctk commands

      See 'dctk help <command>' for information on a specific command.
EOS
    result=$("$bin"/dctk help)
    assert equal "$expected" "$result"
  end

  it 'sets the _DCTK_ROOT environment variable'; (
    source "$bin"/dctk
    dctk_exports
    assert equal "$root"/dctk "$(printenv _DCTK_ROOT)"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end
end

describe 'find_command'
  it 'finds a command in libexec'; (
    source "$bin"/dctk
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
    source "$bin"/dctk
    # shellcheck disable=SC2154
    dir=$($mktempd) || return 1
    find_command file dir
    assert unequal 0 $?
    # shellcheck disable=SC2154
    cleanup "$dir"
    return "$_shpec_failures" )
  end

  it 'finds the first command in a non-libexec root'; (
    source "$bin"/dctk
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

  # it 'finds the command under bin in a non-libexec root'; (
  #   source "$bin"/dctk
  #   # shellcheck disable=SC2154
  #   dir=$($mktempd) || return 1
  #   # shellcheck disable=SC2154
  #   $mkdir "$dir"/dir1
  #   $mkdir "$dir"/dir2/bin
  #   touch "$dir"/dir2/bin/file
  #   chmod +x "$dir"/dir2/bin/file
  #   result=$(find_command file "$dir"/dir1 "$dir"/dir2)
  #   assert equal "$dir"/dir2/bin/file "$result"
  #   # shellcheck disable=SC2154
  #   cleanup "$dir"
  #   return "$_shpec_failures" )
  # end
end

describe 'search_root'
  it 'finds a command in libexec'; (
    source "$bin"/dctk
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
end
