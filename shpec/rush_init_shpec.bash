export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"

set -o nounset

source kaizen.bash imports='
  absolute_dirname
  bring
  get
  globbing
'
$(bring '
  cd
  cptree
  mktempd
  rmtree
' from kaizen.commands)

absolute_dirname "$BASH_SOURCE"
root=$__/..

describe init
  it "outputs a message with no input"; ( _shpec_failures=0
    dir=$($mktempd) || return
    globbing on
    $cptree "$root"/* "$dir"
    globbing off
    $cd "$dir"
    "$dir"/prepare rush >/dev/null
    result=$("$dir"/bin/rush init 2>&1)
    get <<'    EOS'
      # Load rush automatically by adding
      # the following to ~/.bash_profile:

      eval "$(%s/rush init -)"
    EOS
    printf -v __ "\n$__" "$dir"/bin
    assert equal "$__" "$result"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end

  it "outputs a message with input help"; ( _shpec_failures=0
    dir=$($mktempd) || return
    globbing on
    $cptree "$root"/* "$dir"
    globbing off
    $cd "$dir"
    "$dir"/prepare rush >/dev/null
    result=$("$dir"/bin/rush init -)
    get <<'    EOS'
      PATH+=:%q/bin
      for file in %q/completions/*.bash; do
        source "$file"
      done
      unset -v file
    EOS
    printf -v __ "\n$__" "$dir" "$dir"
    assert equal "$__" "$result"
    $rmtree "$dir"
    return "$_shpec_failures" );: $(( _shpec_failures += $? ))
  end
end
