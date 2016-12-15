source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/../..)
bin=$root/dctk/bin

describe 'dctk'
  it 'outputs a message with no input'; (
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
    return "$_shpec_failures"
  ); end

  it 'outputs a message with input help'; (
    defs expected <<'EOS'
      Usage: dctk <command> [<args>]

      Some useful dctk commands are:
        commands  List all dctk commands

      See 'dctk help <command>' for information on a specific command.
EOS

    result=$("$bin"/dctk help)
    assert equal "$expected" "$result"

    return "$_shpec_failures"
  ); end

  it 'sets the _DCTK_ROOT environment variable'; (
    source "$bin"/dctk
    assert equal "$root"/dctk "$_DCTK_ROOT"

    return "$_shpec_failures"
  ); end
end
