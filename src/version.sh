#!/usr/bin/env bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.8.0
# ARG_OPTIONAL_BOOLEAN([major])
# ARG_OPTIONAL_BOOLEAN([minor])
# ARG_OPTIONAL_BOOLEAN([patch])
# ARG_OPTIONAL_BOOLEAN([rc])
# ARG_POSITIONAL_SINGLE([version])
# ARG_DEFAULTS_POS
# ARG_HELP([<The general help message of my script>])
# ARGBASH_GO

# [ <-- needed because of Argbash

function main() {
  local prefix=''
  local version="${_arg_version/v/}"
  local default_size=patch

  if [[ "$version" != "$_arg_version" ]]; then
    prefix=v
  fi

  local patch_enabled=true
  function _format_version() {
    local major="$1"
    local minor="$2"
    local patch="$3"
    local id="$4"
    local id_count="$5"

    echo -n $prefix

    echo -n $major.$minor
    if [[ $patch_enabled == true ]]; then
      echo -n .$patch
    fi

    if [[ -n "$id" ]]; then
      echo "-$id.$id_count"
    else
      echo ''
    fi
  }

  local current_major=$( echo $version | cut -d. -f1 )
  local current_minor=$( echo $version | cut -d. -f2 )
  local current_patch=$( echo $version | cut -d. -f3 )
  local identifier=''
  local current_id=''

  if [[ "$( echo $version | cut -d- -f2 )" != "$version" ]]; then
    identifier=$( echo $version | cut -d- -f2 | cut -d. -f1 )
    current_id=$( echo $version | cut -d- -f2 | cut -d. -f2 )
  fi

  if [[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+(.*)$ ]]; then
    :
  else
    patch_enabled=false
    default_size=minor
  fi

  for s in major minor patch rc; do
    var=_arg_$s
    if [[ ${!var} != off ]]; then
      size=$s
    fi
  done

  for s in rc; do
    var=_arg_$s
    if [[ ${!var} != off && -z "$identifier" ]]; then
      identifier=$s

      # The next version if adding an rc flag should be the next lowest version
      if [[ $patch_enabled == true ]]; then
        current_patch=$((current_patch+1))
      else
        current_minor=$((current_minor+1))
      fi
    fi
  done

  # If the identifier is set to rc and we have not explicitly specified a bump,
  #  then we can assume that we only need to strip the rc flag.  I.e. it is no
  #  longer a release candidate, but a release itself.
  if [[ -z "$size" && "$identifier" == rc ]]; then
    if [[ $patch_enabled == true ]]; then
      current_patch=$((current_patch-1))
    else
      current_minor=$((current_minor-1))
    fi
  fi

  case ${size:-$default_size} in
    patch )
      _format_version $((current_major)) $((current_minor)) $((current_patch+1))
      ;;
    minor )
      _format_version $((current_major)) $((current_minor+1)) 0
      ;;
    major )
      _format_version $((current_major+1)) 0 0
      ;;
    rc )
      _format_version $((current_major)) $((current_minor)) $((current_patch)) ${identifier} $((current_id+1))
      ;;
  esac
}

main "${@:-}"
exit $?

# ] <-- needed because of Argbash
