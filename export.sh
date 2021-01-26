#!/bin/bash

ROOMLIST=""
EXTRA=""
while [ $# -gt 0 ]; do
  case "$1" in
    --user=*)
      USER_ID="${1#*=}"
      ;;
    --password=*)
      USERPASS="${1#*=}"
      ;;
    --keyspass=*)
      KEYSPASS="${1#*=}"
      ;;
    --keys=*)
      KEYS="${1#*=}"
      ;;
    --user=*)
      USER_ID="${1#*=}"
      ;;
    --server=*)
      SERVERURL="${1#*=}"
      ;;
    --media)
      EXTRA=""
      ;;
    --no-media)
      EXTRA="--no-media"
      ;;
    --all-rooms)
      ROOMLIST="--all-rooms"
      EXTRA="$EXTRA --batch"
      ;;
    --list-rooms)
      ROOMLIST="--listrooms"
      ;;
    --room=*)
      EXTRA="$EXTRA --batch"
      ROOMLIST="$ROOMLIST --room=!${1#*=}:smart4.io"
      ;;
    --h|*)
      printf "***************************\n"
      printf "export --user=USERID --password=USERPASS --keys=KEYFILES --keyspass=KEYSPASS --server=SERVER URL [--media | --no-media ] [--list-rooms|room=ROOM|--all-rooms]\n"
      printf "USERID is name:domain without the @\n"
      printf "SERVER URL including https://\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

if [ -z "$ROOMLIST" ]; then
	ROOMLIST="--all-rooms"
fi

USER=${USER_ID%:*}

TARGET=""
if [ "$ROOMLIST" != "--listrooms" ] ; then
	TARGET="$USER.${USER_ID#*:}.backup"
fi

echo "Starting export, this may take a while"

python3 -m venv venv && source venv/bin/activate && python3 -u matrix-archive.py --server $SERVERURL --user @$USER_ID --userpass $USERPASS --keyspass $KEYSPASS $ROOMLIST $EXTRA $ALLROOMS --keys $KEYS $TARGET 2>&1
if [ "$ROOMLIST" != "--listrooms" ] ; then
	tar czf $USER_ID.tgz $TARGET.
fi

echo "*********************"
echo "Export completed"
echo "*********************"
