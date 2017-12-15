export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p -- "$TMPDIR"

set -o nounset

source kaizen.bash imports='
  absolute_dirname
  bring
  get
'

absolute_dirname "$BASH_SOURCE"
root=$__/../..
bin=$root/bin
completions=$root/completions
libexec=$root/dctk/libexec

describe init
  it "outputs a message with no input"; ( _shpec_failures=0
    get <<'    EOS'
      # Load dctk automatically by adding
      # the following to ~/.bash_profile:

      eval "$(%s/dctk init -)"
    EOS
    printf -v expected "$__" "$bin"
    result=$("$libexec"/init 2>&1 1>/dev/null)
    assert equal "$expected" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message with input -"; ( _shpec_failures=0
    get <<'    EOS'
      \nexport PATH+=:%s
      for file in %q/*.bash; do
        source "$file"
      done
      unset -v file
    EOS
    printf -v expected "$__" "$bin" "$completions"
    result=$("$libexec"/init -)
    assert equal "$expected" "$result"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
