#!/bin/bash

if [ "$(uname)" == 'Darwin' ]; then
  OS='Mac'
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  OS='Linux'
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
  OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

if [ "$(basename $0)" == 'zenit-beta' ]; then
  BETA_VERSION=true
else
  BETA_VERSION=
fi

while getopts ":wtfvh-:" opt; do
  case "$opt" in
    -)
      case "${OPTARG}" in
        wait)
          WAIT=1
          ;;
        help|version)
          REDIRECT_STDERR=1
          EXPECT_OUTPUT=1
          ;;
        foreground|test)
          EXPECT_OUTPUT=1
          ;;
      esac
      ;;
    w)
      WAIT=1
      ;;
    h|v)
      REDIRECT_STDERR=1
      EXPECT_OUTPUT=1
      ;;
    f|t)
      EXPECT_OUTPUT=1
      ;;
  esac
done

if [ $REDIRECT_STDERR ]; then
  exec 2> /dev/null
fi

if [ $OS == 'Mac' ]; then
  if [ -n "$BETA_VERSION" ]; then
    ZENIT_APP_NAME="Zenit Beta.app"
  else
    ZENIT_APP_NAME="Zenit.app"
  fi

  if [ -z "${ZENIT_PATH}" ]; then
    # If ZENIT_PATH isnt set, check /Applications and then ~/Applications for Zenit.app
    if [ -x "/Applications/$ZENIT_APP_NAME" ]; then
      ZENIT_PATH="/Applications"
    elif [ -x "$HOME/Applications/$ZENIT_APP_NAME" ]; then
      ZENIT_PATH="$HOME/Applications"
    else
      # We havent found an Zenit.app, use spotlight to search for Zenit
      ZENIT_PATH="$(mdfind "kMDItemCFBundleIdentifier == 'me.iiegor.zenit'" | grep -v ShipIt | head -1 | xargs -0 dirname)"

      # Exit if Zenit can't be found
      if [ ! -x "$ZENIT_PATH/$ZENIT_APP_NAME" ]; then
        echo "Cannot locate Zenit.app, it is usually located in /Applications. Set the ZENIT_PATH environment variable to the directory containing Zenit.app."
        exit 1
      fi
    fi
  fi

  if [ $EXPECT_OUTPUT ]; then
    "$ZENIT_PATH/$ZENIT_APP_NAME/Contents/MacOS/Zenit" --executed-from="$(pwd)" --pid=$$ "$@"
    exit $?
  else
    open -a "$ZENIT_PATH/$ZENIT_APP_NAME" -n --args --executed-from="$(pwd)" --pid=$$ --path-environment="$PATH" "$@"
  fi
elif [ $OS == 'Linux' ]; then
  SCRIPT=$(readlink -f "$0")
  USR_DIRECTORY=$(readlink -f $(dirname $SCRIPT)/..)

  if [ -n "$BETA_VERSION" ]; then
    ZENIT_PATH="$USR_DIRECTORY/share/zenit-beta/zenit"
  else
    ZENIT_PATH="$USR_DIRECTORY/share/zenit/zenit"
  fi

  ZENIT_HOME="${ZENIT_HOME:-$HOME/.zenit}"
  mkdir -p "$ZENIT_HOME"

  : ${TMPDIR:=/tmp}

  [ -x "$ZENIT_PATH" ] || ZENIT_PATH="$TMPDIR/zenit-build/Zenit/zenit"

  if [ $EXPECT_OUTPUT ]; then
    "$ZENIT_PATH" --executed-from="$(pwd)" --pid=$$ "$@"
    exit $?
  else
    (
    nohup "$ZENIT_PATH" --executed-from="$(pwd)" --pid=$$ "$@" > "$ZENIT_HOME/nohup.out" 2>&1
    if [ $? -ne 0 ]; then
      cat "$ZENIT_HOME/nohup.out"
      exit $?
    fi
    ) &
  fi
fi

# Exits this process when Zenit is used as $EDITOR
on_die() {
  exit 0
}
trap 'on_die' SIGQUIT SIGTERM

# If the wait flag is set, don't exit this process until Zenit tells it to.
if [ $WAIT ]; then
  while true; do
    sleep 1
  done
fi