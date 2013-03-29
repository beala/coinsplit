#!/bin/bash
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

function fail {
	echo "Failed: $1"
	exit 1
}

grep universe /etc/apt/sources.list &> /dev/null
if [[ $? != 0 ]]; then
	echo "Add universe to /etc/apt/sources.list"
	exit 1
fi

sudo apt-get update || fail "Couldn't apt-get update"
sudo apt-get install vim build-essential python-dev python-setuptools ssss || fail "Couldn't apt-get install."
sudo easy_install xkpa || fail "Couldn't install xkpa."

echo
echo "Success!"
