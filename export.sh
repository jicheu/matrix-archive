#!/bin/bash

[ ! -d ".env" ] && mkdir .env
[ ! -d ".target" ] && mkdir .target

ROOMLIST=""
EXTRA=""
KEYS=""
COMMANDE="$0 $@"
RESTART=0

create_room_list() {
	ROOMLIST=""
        EXTRA="--batch"
      	for i in `cat .env/rooms_list.@$USER_ID.txt` 
      	do 
		  ROOMLIST="$ROOMLIST --room=!$i:smart4.io"
      	done 
}

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
    --all-rooms)
      ROOMLIST="--all-rooms"
      EXTRA="--batch"
      ;;
    --list-rooms)
      ROOMLIST="--listrooms"
      ;;
    --room=*)
      EXTRA="--batch"
      ROOMLIST="$ROOMLIST --room=!${1#*=}:smart4.io"
      ;;
    --my-rooms)
      if [ ! -f ".env/rooms_list.@$USER_ID.txt" ]; then
	printf "first run with --my-rooms, selecting rooms\n"
	ROOMLIST="--listrooms"
	EXTRA=""
	RESTART=1
      else 
	create_room_list
      fi
      ;;
    --h|*)
      printf "***************************\n"
      printf "export --user=USERID --password=USERPASS --keys=KEYFILES --keyspass=KEYSPASS --server=SERVER URL [--media | --no-media ] [--list-rooms|room=ROOM|--all-rooms|--my-rooms]\n"
      printf "USERID is name:domain without the @\n"
      printf "SERVER URL including https://\n"
      printf "keys can be omitted if previously sent\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

printf "Looking for keys..."
if  [ -z "$KEYS" ] && [ -f ".env/$USER_ID.keys" ]; then 
	printf "Key already present!\n"
elif  [ -z "$KEYS" ] && [ ! -f ".env/$USER_ID.keys" ] && [ -f "/tmp/$USER_ID.keys" ]; then
	printf "Copying keys from file found in /tmp\n"
	cp /tmp/$USER_ID.keys .env
elif [ ! -z "$KEYS" ]; then
	printf "Copying new key provided in command line\n"
	cp $KEYS .env/$USER_ID.keys
else
	  printf "\n**********************\nCannot find keys anywhere, copy your keys to the server at /tmp/$USER_ID.keys\n"
	  exit 1
fi 

KEYS=".env/$USER_ID.keys"
[ -z "$ROOMLIST" ] && ROOMLIST="--all-rooms";EXTRA="--batch"

USER=${USER_ID%:*}

TARGET=""
[ "$ROOMLIST" != "--listrooms" ] && TARGET=".env/$USER.${USER_ID#*:}.backup"

echo "Starting export, this may take a while"

#python3 -m venv venv && source venv/bin/activate && pip3 install -r requirements.txt && python3 -u matrix-archive.py --server $SERVERURL --user @$USER_ID --userpass $USERPASS --keyspass $KEYSPASS $ROOMLIST $EXTRA $ALLROOMS --keys $KEYS $TARGET 2>&1
python3 -m venv venv && source venv/bin/activate && python3 -u matrix-archive.py --server $SERVERURL --user @$USER_ID --userpass $USERPASS --keyspass $KEYSPASS $ROOMLIST $EXTRA $MEDIA $ALLROOMS --keys $KEYS $TARGET 2>&1
[ "$ROOMLIST" != "--listrooms" ] && tar czf .target/$USER_ID.tgz $TARGET

if [ $RESTART -eq 1 ]; then
   printf "Restarting\n";
   create_room_list
   python3 -u matrix-archive.py --server $SERVERURL --user @$USER_ID --userpass $USERPASS --keyspass $KEYSPASS $ROOMLIST $EXTRA $MEDIA $ALLROOMS --keys $KEYS $TARGET 2>&1
fi
printf "Finished\n"
