#!/bin/sh

# negdiv: A script to remove the orange mask from a color negative film scan.
# Copyright (C) 2015 Antti Penttala (http://www.penttala.fi/blog/)
 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

function usage {
	echo "Version: negdiv 1.0"
	echo "Copyright (C) 2015 Antti Penttala (http://www.penttala.fi/blog/category/negdiv/)"
	echo "License: http://www.gnu.org/licenses/old-licenses/gpl-2.0.html"
	echo ""
	echo "Usage: negdiv [options ...] maskfile framefile ..."
	echo ""
	echo "General options:"
	echo "  -a        Use autotone script by Fred Weinhaus to finalize the image"
	echo "            (http://www.fmwconcepts.com/imagemagick/autotone/index.php)"
	echo "  -j        Output in jpg format"
	echo "  -p path   Output to path instead of current directory"
	echo "  -q        Keep quiet"
	echo ""
	echo "Autotone options (when -a is selected):"
	echo "  -n none   Do not reduce noise"
	echo "  -n auto   Use autotone defaults for noise reduction instead of negdiv defaults"
	echo "  -n 2.0    Pass the float value to autotone for noise reduction parameter"
	echo "  -s none   Do not shorpen"
	echo "  -s auto   Use autotone defaults for sharpening instead of negdiv defaults"
	echo "  -s 3.0    Pass the float value to autotone for sharpening parameter"
	echo ""
}

OUTPUT_JPG=0
USE_AUTOTONE=0
AUTOTONE_SHARPEN_ARGS=( "-S" "2.0" )
AUTOTONE_NOISE_ARGS=( "-N" "1.5" )
OUTPUT_PATH=""
QUIET=0
AUTOTONE="autotone"

while getopts "ajn:p:qs:" opt; do
	case $opt in
		a)
			USE_AUTOTONE=1
			;;
		j)
			OUTPUT_JPG=1
			;;
		n)
			if [ "$OPTARG" == "auto" ]; then
				AUTOTONE_NOISE_ARGS=(  )
			elif [ "$OPTARG" == "none" ]; then
				AUTOTONE_NOISE_ARGS=( "-n" )
			else
				AUTOTONE_NOISE_ARGS=( "-N" "$OPTARG" )
			fi
			;;
		p)
			OUTPUT_PATH=$OPTARG
			;;
		q)
			QUIET=1
			;;
		s)
			if [ "$OPTARG" == "auto" ]; then
				AUTOTONE_SHARPEN_ARGS=(  )
			elif [ "$OPTARG" == "none" ]; then
				AUTOTONE_SHARPEN_ARGS=( "-s" )
			else
				AUTOTONE_SHARPEN_ARGS=( "-S" "$OPTARG" )
			fi
			;;
	esac
done
shift $((OPTIND-1))

if [ $# -lt 2 ]; then
	usage
	exit 1
fi

MASK_COLOR=`convert "$1" -quiet -resize 1x1\! txt:- | tail -n +2 | sed 's/.*rgb/rgb/'`
shift

for INPUT_FILE in "$@"
do
	BASE_FILE=`basename "$INPUT_FILE"`
	if [ "$OUTPUT_PATH" != "" ]; then
		OUTPUT_FILE="$OUTPUT_PATH/pos_$BASE_FILE"
	else
		OUTPUT_FILE="pos_$BASE_FILE"
	fi
	if [ $OUTPUT_JPG -ne 0 ]; then
		OUTPUT_FILE="${OUTPUT_FILE%.*}.jpg"
	fi
	if [ $QUIET -eq 0 ]; then	
		echo "Converting $OUTPUT_FILE"
	fi
	if [ "$USE_AUTOTONE" -ne "0" ]; then
		convert "$INPUT_FILE" -alpha off -fill $MASK_COLOR -colorize 100% - \
		| composite - "$INPUT_FILE" -compose Divide_Src - \
		| convert -negate - - \
		| $AUTOTONE ${AUTOTONE_SHARPEN_ARGS[@]} ${AUTOTONE_NOISE_ARGS[@]} /dev/stdin "$OUTPUT_FILE"
	else
		convert "$INPUT_FILE" -alpha off -fill $MASK_COLOR -colorize 100% - \
		| composite - "$INPUT_FILE" -compose Divide_Src - \
		| convert -negate - "$OUTPUT_FILE"
	fi
done

