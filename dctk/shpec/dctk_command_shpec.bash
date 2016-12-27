source shpec-helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname root)
root=$(absolute_path "$root"/../..)
bin=$root/dctk/bin

describe 'dctk command'
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
end
