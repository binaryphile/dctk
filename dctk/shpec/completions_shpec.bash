source shpec-helper.bash
initialize_shpec_helper

libexec=$(realpath "$BASH_SOURCE")
libexec=$(dirname libexec)
libexec=$(absolute_path "$libexec"/../libexec)

source "$libexec"/completions

describe 'completions'
  it 'outputs a message with input help'; (
    defs expected <<'EOS'
      commands
      completions
      help
      init
EOS
    result=$("$libexec"/completions help)
    # shellcheck disable=SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'looks for the leading comment'; (
    # shellcheck disable=SC2016
    stub_command grep 'echo "$2"'
    stub_command exec ':'
    result=$(completions_main help)
    # shellcheck disable=SC2154
    assert equal "# completions: true" "$result"
    return "$_shpec_failures" )
  end

  it "doesn't return a completion for completions"; (
    result=$("$libexec"/completions completions)
    # shellcheck disable=SC2154
    assert equal "" "$result"
    return "$_shpec_failures" )
  end
end
