#! /bin/sh

### HELPER #########################################################

function inc() { (( $1 = ${!1} + 1)); }
function dec() { (( $1 = ${!1} - 1)); }

### HELP ###########################################################

usage() {
  (                                     
    echo "$@"                          
    echo                                
    (test "$USAGE" && echo "$USAGE")    \
    || cat "$(dirname $0)/README.md"    \
        2>/dev/null                     \
    || man "$(basename "$0")"           
  ) 1>&2
  exit 1
}

### VARIABLES ######################################################

ARGV=( )

setpvo() {
  pvO=( $@ )
  test ${#pvO[@]} -gt 1 || usage "There must be at least two pages"
}

setNpvo() { 
  pvO=( $(seq "$1") )
}

setfile() {
  test -x "$1" -o -n "$justtransform" || usage "Given file does not exist"
  file="$1"
}

# OPTIONS -----------------

while getopts 'n:s:f:te' OPTION; do
  case $OPTION in
    'e')
      lastempty=true
      ;;

    't')
      justtransform=true
      ;;

    'f')
      file="$OPTARG"
      ;;

    'n')
      setNpvo "$OPTARG"
      ;;

    's')
      setpvo "$OPTARG"
      ;; 
      
    'h')
      usage
      ;;

    ?)
      usage "Unknown option"
      ;;

    -)
      ARGV+=( "$OPTARG" )
      ;;
  esac
done

# ARGUMENTS --------------------
# Rest of the args
shift $((OPTIND-1))
ARGV+=( $@ )

# ARG1 pvO
if ! [ $pvO ]; then
  setNpvo "$1"
  shift
fi

# ARG2
if [ ! $file ]; then
  setfile "$1"
  shift
fi

test "$@" && usage "Too many arguments!"

# CONSTANTS ----------------------

empty="{}"

### FILL VECTOR ####################################################

# Append empty last page
test $lastempty && pvO+=( "$empty" )

# Append empty pages until len is a multiple of 4
((app= 4 - ${#pvO[@]} % 4)) # Get required additional pages
while [ $app -gt 0 ]; do
  pvO+=( "$empty" )
  dec app
done

### TRANSFORM ######################################################

# Generate new pvOector
i=0
((k=${#pvO[@]}-1))
pvN=( )
while [ $k -gt $i ]; do
    pvN+=( ${pvO[$k]} )
    pvN+=( ${pvO[$i]} )
    inc i; dec k

    test $k -gt $i || break
    pvN+=( ${pvO[$i]} )
    pvN+=( ${pvO[$k]} )
    inc i; dec k
done

### OUTPUT #############################################################

if [ $justtransform ]; then
  echo ${pvN[@]}
else
  echo pdfjam --twoside --suffix book --nup '2x1' --landscape -- "$file" ${pvN[@]}
fi
