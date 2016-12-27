source shpec-helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/../..)
libexec=$root/dctk/libexec
bin=$root/bin
completions=$root/completions

describe 'init'
  it 'outputs a message with no input'; (
    defs expected <<'EOS'
      # Load dctk automatically by adding
      # the following to ~/.bash_profile:

      eval "$(%s/dctk init -)"
EOS
    # shellcheck disable=SC2030,SC2059
    printf -v expected "$expected" "$bin"
    result=$("$libexec"/init 3>&2 2>&1 1>&3)
    # shellcheck disable=SC2016,SC2154
    assert equal "$expected" "$result"
    # shellcheck disable=SC2154
    return "$_shpec_failures" )
  end

  it 'outputs a message with input -'; (
    defs expected <<'EOS'
      export PATH=$PATH:%s
      for file in %q/*.bash; do
        source "$file"
      done
      unset -v file
EOS
    # shellcheck disable=SC2031,SC2059
    printf -v expected "$expected" "$bin" "$completions"
    result=$("$libexec"/init -)
    # shellcheck disable=SC2016
    assert equal "$expected" "$result"
    return "$_shpec_failures" )
  end
end
