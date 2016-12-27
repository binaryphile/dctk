source shpec-helper.bash
initialize_shpec_helper

libexec=$(realpath "$BASH_SOURCE")
libexec=$(dirname "$libexec")
libexec=$(absolute_path "$libexec"/../libexec)

describe 'help'
  it 'outputs a message with no input'; (
    defs expected <<'EOS'
      Usage: dctk <command> [<args>]

      Some useful dctk commands are:
         commands  List all dctk commands

      See 'dctk help <command>' for information on a specific command.
EOS
    result=$("$libexec"/help)
    # shellcheck disable=SC2154
    assert equal "${expected}" "${result%}"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'outputs a message for commands'; (
    defs expected <<'EOS'
      Usage: dctk commands

      This command is mostly used for autocompletion in various shells, and for `dctk help`.
EOS
    result=$("$libexec"/help commands)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"
    return "$_shpec_failures" )
  end

  it 'outputs a message for completions'; (
    result=$("$libexec"/help completions)
    assert equal "Sorry, this command isn't documented yet." "$result"
    return "$_shpec_failures" )
  end

  it 'outputs a message for help'; (
    result=$("$libexec"/help help)
    assert equal "Sorry, this command isn't documented yet." "$result"
    return "$_shpec_failures" )
  end

  it 'outputs a message for init'; (
    result=$("$libexec"/help init)
    assert equal "Sorry, this command isn't documented yet." "$result"
    return "$_shpec_failures" )
  end
end
