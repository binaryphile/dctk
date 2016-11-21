source shpec_helper.bash
initialize_shpec_helper

root=$(realpath "$BASH_SOURCE")
root=$(dirname "$root")
root=$(absolute_path "$root"/..)
libexec=$root/libexec
bin=$root/bin

PATH=$libexec:$PATH


describe "dctk-init"
  it "outputs a message with no input"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
# Load dctk automatically by adding
# the following to ~/.bash_profile:

eval "$(%s/dctk init -)"
EOS

    # shellcheck disable=SC2030,SC2059
    printf -v expected "$expected" "$bin"
    result=$("$libexec"/dctk-init 2>&1)
    # shellcheck disable=SC2016,SC2154
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end

  it "outputs a message with input help"; ( _shpec_failures=0   # shellcheck disable=SC2030

    define expected <<'EOS'
export PATH=$PATH:%s
source %s/completions/dctk.bash
_dctk_wrapper() {
  local command=$1

  (( $# > 0 )) && shift

  case $command in
    "shell" )
      eval $(dctk sh-"$command" "$@")
      ;;
    * )
      command dctk "$command" "$@"
      ;;
  esac
}
alias dctk=_dctk_wrapper
EOS

    # shellcheck disable=SC2031,SC2059
    printf -v expected "$expected" "$bin" "$root"
    result=$("$libexec"/dctk-init -)
    # shellcheck disable=SC2016
    assert equal "$expected" "$result"

    return "$_shpec_failures" ); (( _shpec_failures += $? )) ||:
  end
end
