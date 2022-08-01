#!/bin/bash
# Created by Jamey Hopkins
# Random pick files that represent YouTube videos.
# Place file containing video to play in location used by web site for displaying random videos.

# 20100427 jah - youtuberand.sh -> yt2.sh
#                conversion to 0 byte file use
#                cut out email
# 20100527 jah - create a .selected file for reference
# 20110214 jah - use /bin/bash since ubuntu uses dash for sh which is not compat. w/ FILE=($FILES)
# 20220731 jah - make selection based on what shoutcast service is currently playing 
#
# NOTE: use vid.1.yt2, vid.same.yt, etc, to specify the same video more than once (increase odds)
#       move *.yt to *.yt.off (or some other extension) to disable selection
#

echo

cd /root/Scripts/yt2.ic

CURRENT=`curl -s http://industrialcomplex.de:8000/currentsong?sid=1`
#CURRENT="God Module - Plastic"
WORKDIR="`pwd`"

# select from currently playing directory if nothing specific passed
[ "$1" = "" -a -d "$CURRENT" ] && WORKDIR="${WORKDIR}/$CURRENT" && cd "$CURRENT"

# match specific or all random, default is base directory unless there was a currently playing directory match
# use -- to handle files that start with -
[ "$1" != "" ] && FILES=`ls -- *$1*.yt 2>/dev/null` || FILES=`ls -- *.yt 2>/dev/null`

echo "Matching Files:"
echo "$FILES"

# perform random magic
FILE=($FILES)
NFILES=${#FILE[*]} #count
VID=`echo ${FILE[$((RANDOM%NFILES))]}`

echo
echo "Picked -> $VID"
echo "Directory -> $WORKDIR"
echo "Currently playing -> $CURRENT"

# send random youtube string to file for web/php processing
echo "$VID" | cut -f1 -d. > /var/www/industrialcomplex.de/random.youtube

rm -- *selected >/dev/null 2>&1
cp -- $VID $VID.selected

echo


