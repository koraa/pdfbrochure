#! /bin/sh

# Helper
function inc() { (( $1 = ${!1} + 1)); }
function dec() { (( $1 = ${!1} - 1)); }

# Constants
empty="{}"

# ARGS
appempty=true

# Page vector/contains all pages sequentially; destination vector
pvO=( $(seq $1) )
pvN=( )

# Append empty last page
test $appempty && pvO+=( "$empty" )

# Append empty pages until len is a multiple of 4
((app= 4 - ${#pvO[@]} % 4)) # Get required additional pages
while [ $app -gt 0 ]; do
  pvO+=( "$empty" )
  dec app
done

# Generate new pvOector
i=0
((k=${#pvO[@]}-1))
while [ $k -gt $i ]; do
    pvN+=( ${pvO[$k]} )
    pvN+=( ${pvO[$i]} )
    inc i; dec k

    test $k -gt $i || break
    pvN+=( ${pvO[$i]} )
    pvN+=( ${pvO[$k]} )
    inc i; dec k
done
echo $DBG; inc DBG

echo ${pvN[@]}
