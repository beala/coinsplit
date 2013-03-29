#!/bin/bash
# Uses my xkpa password generator: https://github.com/beala/xkcd-password
# The password generation method can be modified below.
# Depends on openssl and ssss (http://point-at-infinity.org/ssss/)

# Copyright (c) 2013 Alex Beal
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

SECRETGEN="xkpa -n 10"

usage() {
    cat << EOF
Encrypts a file and splits an autogenerated key.
Shares of the key are output to n text files in
the current directory.

OPTIONS:
    -t      Number of shares needed to recreate the secret.
    -n      Number of shares to generate.
    -o      Name of files to output shares to.
    -h      Output this message.
EOF
}

while getopts "ho:t:n:" OPTION; do
    case "$OPTION" in
        h)
            usage
            exit 1
            ;;
        t)
            THRESHOLD="$OPTARG"
            ;;
	n)
	    SHARESCOUNT="$OPTARG"
	    ;;
	o)
	    SHARESOUT="$OPTARG"
	    ;;
    esac
done

DIE=false
if [[ -z "$THRESHOLD" ]]; then
    echo "Error: Missing shares threshold."
    DIE=true
fi
if [[ -z "$SHARESCOUNT" ]]; then
    echo "Error: Missing shares count."
    DIE=true
fi
if [[ -z "$SHARESOUT" ]]; then
    echo "Error: Missing shares count."
    DIE=true
fi
if [[ $DIE == true ]]; then
    echo
    usage
    exit 1
fi

# Generate the secret.
SECRET="$($SECRETGEN)"

# Split the secret into shares.
shares="$(ssss-split -t "$THRESHOLD" -n "$SHARESCOUNT" -q <<< "$SECRET")"
if [[ $? != 0 ]]; then
    echo "Error: Secret splitting failed."
    exit 1
fi

echo "Secret: $SECRET"

# Write each share to a different file.
i=0
for share in $shares; do
    echo $share
    echo "$share" > "$SHARESOUT-$i"
    i=$((i+1))
done