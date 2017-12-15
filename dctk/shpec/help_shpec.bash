export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p -- "$TMPDIR"

set -o nounset

source kaizen.bash imports='
  absolute_dirname
  bring
  get
'
$(bring '
  echo
  mktempd
  rmtree
  touch
' from kaizen.commands)

absolute_dirname "$BASH_SOURCE"
libexec=$__/../libexec
source "$libexec"/help

describe help
  it "outputs a message with no input"; ( _shpec_failures=0
    get <<'    EOS'
      Usage: dctk <command> [<args>]

      Some useful dctk commands are:
        commands  List all dctk commands

      See 'dctk help <command>' for information on a specific command.
    EOS
    result=$("$libexec"/help)
    assert equal "$__" "${result#$'\n'}"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message for commands"; ( _shpec_failures=0
    result=$("$libexec"/help commands)
    get <<'    EOS'
      Usage: dctk commands

      This command is mostly used for autocompletion in various shells, and for `dctk help`.
    EOS
    assert equal "$__" "${result#$'\n'}"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message for completions"; ( _shpec_failures=0
    result=$("$libexec"/help completions)
    assert equal "Sorry, this command is not documented yet." "${result#$'\n'}"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message for help"; ( _shpec_failures=0
    result=$("$libexec"/help help)
    assert equal "Sorry, this command is not documented yet." "${result#$'\n'}"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message for init"; ( _shpec_failures=0
    result=$("$libexec"/help init)
    assert equal "Sorry, this command is not documented yet." "${result#$'\n'}"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe command_path
  it "reports the path of a program"; ( _shpec_failures=0
    dir=$($mktempd) || return
    touch "$dir"/sample
    chmod +x "$dir"/sample
    command_path "$dir" sample
    assert equal "$dir"/sample "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "reports the path of a program with a sh- prefix"; ( _shpec_failures=0
    dir=$($mktempd) || return
    touch "$dir"/sh-sample
    chmod +x "$dir"/sh-sample
    command_path "$dir" sample
    assert equal "$dir"/sh-sample "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "reports the path of a program when there's also a sh- prefix"; ( _shpec_failures=0
    dir=$($mktempd) || return
    touch "$dir"/sample
    chmod +x "$dir"/sample
    touch "$dir"/sh-sample
    chmod +x "$dir"/sh-sample
    command_path "$dir" sample
    assert equal "$dir"/sample "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe help
  it "returns help"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $echo "# Help: sample" >"$dir"/sample.txt
    help "$dir"/sample.txt
    assert equal sample "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "returns multline help"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $echo $'# Help: sample\n# another line' >"$dir"/sample.txt
    help "$dir"/sample.txt
    assert equal $'sample\nanother line' "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "returns blank when no help"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $touch "$dir"/sample.txt
    help "$dir"/sample.txt
    assert equal '' "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe summary
  it "returns a summary"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $echo "# Summary: sample" >"$dir"/sample.txt
    summary "$dir"/sample.txt
    assert equal sample "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "returns blank if no summary"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $touch "$dir"/sample.txt
    summary "$dir"/sample.txt
    assert equal '' "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end

describe usage
  it "returns usage"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $echo "# Usage: sample" >"$dir"/sample.txt
    usage "$dir"/sample.txt
    assert equal "Usage: sample" "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "says if usage is not found"; ( _shpec_failures=0
    dir=$($mktempd) || return
    $echo >"$dir"/sample.txt
    usage "$dir"/sample.txt
    assert equal "Sorry, this command is not documented yet." "$__"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
