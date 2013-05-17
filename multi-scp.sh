#!/bin/sh

GROUP_PATH=./groups/

# print usage info
usage () {
    echo "usage: $0 [OPTION] <LOCAL_FILE> <REMOTE_PATH>"
    echo "  -g|--group <GROUPNAME>      (all|all-rhel6|all-squeezy)"
    echo "  -n|--dry-run		don't run any command, only show them"
    echo "  Copies the local file to all hosts in specified group(s) into the specified path."
    exit
}

if [ $# -eq 0 ]; then
  usage;
fi

gflag=0
dryrunflag=0

# Parse the command-line options
TEMP=`getopt -o g:n --long group:,dry-run \
     -n $0 -- "$@"`

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
  case "$1" in
    -g|--group) gflag=1;
      case "$2" in
        "") echo "Groupname missing!"; usage; shift 2 ;;
        *) GROUP=$2; shift 2 ;;
      esac ;;
    -n|--dry-run) dryrunflag=1; shift ;;
    --) shift; break ;;
    *) echo "Internal error!" ; exit 1 ;;
  esac
done

if [[ $gflag = 0 ]]; then
  usage;
fi

## generate grouplist
GROUP_LIST=""

### all
if [[ "$GROUP" == "all" ]]; then
  GROUP_LIST=`cat $GROUP_PATH/*`
else
  ### location and type?
  LOCATION_AND_TYPE=$(echo $GROUP |awk '/[a-z]+-[a-z]+/ { print 1 }')
  if [[ "$LOCATION_AND_TYPE" = "1" ]]; then
    #echo "Location and Type"
    GROUP_LIST=$(cat $GROUP_PATH/$GROUP)
  else
    GROUP_LIST=$(cat $GROUP_PATH/*${GROUP}*)
  fi
fi

## initialize some vars
HOST=""
PORT=""

## loop through servers in group and execute specified command
for i in $GROUP_LIST; do
  ### ignore if first char is #
  IS_COMMENT=$(echo $i |cut -c1)
  if [[ "$IS_COMMENT" == "#" ]]; then
    continue
  fi
  echo "### $i ###"
  HOST=`echo $i |cut -d":" -f1`
  PORT=`echo $i |cut -s -d":" -f2`
  if [[ "$PORT" == "" ]]; then
    PORT=22
  fi
  if [[ $dryrunflag = 1 ]]; then
    echo "scp -p -P $PORT $1 ${HOST}:$2"
  else
    scp -p -P $PORT $1 ${HOST}:$2
  fi
done
