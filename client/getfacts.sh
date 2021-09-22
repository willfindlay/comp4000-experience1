#!/bin/sh
# SPDX-License-Identifier: MIT
#
# The client-side component of COMP4000 experience 1.
# Copyright (c) 2021  William Findlay
#
# September 21, 2021  William Findlay  Created this.

URL="$ADDR:$PORT/fact"
SECS=10

echo "Getting a new printer fact from $URL every $SECS seconds... Ctrl-C to stop."
while true; do
    curl "$URL"
    sleep "$SECS"
done
