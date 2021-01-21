#!/bin/bash

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
      MEDIA=""
      ;;
    --no-media)
      MEDIA="--no-media"
      ;;
    --h|*)
      printf "***************************\n"
      printf "export --user=USERID --password=USERPASS --keys=KEYFILES --keyspass=KEYSPASS --server=SERVER URL [--media | --no-media ]\n"

      printf "USERID is name:domain without the @\n"
      printf "SERVER URL including https://\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done


USER=${USER_ID%:*}
TARGET=$USER.${USER_ID#*:}


echo "Starting export, this may take a while"

python3 -m venv venv && source venv/bin/activate && python3 -u matrix-archive.py --batch --server $SERVERURL --user @$USER_ID --userpass $USERPASS --keyspass $KEYSPASS --all-rooms $MEDIA --keys $KEYS $TARGET.backup 2>&1
echo "Archiving..."
tar czf $TARGET.tgz $TARGET.backup/
echo ""
echo "*********************"
echo "Export completed"
echo "*********************"
